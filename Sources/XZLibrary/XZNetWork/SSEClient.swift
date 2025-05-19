//
//  File.swift
//  XZLibrary
//
//  Created by Mephisto on 2025/2/15.
//

import Foundation

public actor SSEClient {
    private var request: URLRequest
    private var task: URLSessionDataTask?
    private var session: URLSession?
    private weak var delegate: SSEClientDelegate?

    init(request: URLRequest) {
        self.request = request
    }

    func start() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let sessionConfig = URLSessionConfiguration.default
            let delegate = SSEClientDelegate(continuation: continuation)
            self.delegate = delegate
            self.session = URLSession(configuration: sessionConfig, delegate: delegate, delegateQueue: nil)

            request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
            task = session?.dataTask(with: request)
            task?.resume()

            continuation.onTermination = { @Sendable _ in
                Task {
                    await self.stop()
                }
            }
        }
    }

    public func stop() async {
        task?.cancel()
        task = nil
        session?.invalidateAndCancel()
        session = nil
        delegate = nil
        print("Connection closed.")
    }
}

// 创建一个继承自 NSObject 的代理类
final class SSEClientDelegate: NSObject, URLSessionDataDelegate, @unchecked Sendable {
    var continuation: AsyncThrowingStream<String, Error>.Continuation
    private var buffer = ""
    private var errorData: Data?

    init(continuation: AsyncThrowingStream<String, Error>.Continuation) {
        self.continuation = continuation
    }

    @MainActor
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let httpResponse = dataTask.response as? HTTPURLResponse,
            !(200...299).contains(httpResponse.statusCode)
        {
            errorData = data  // 缓存非 2xx 响应的数据
            return
        }

        if let string = String(data: data, encoding: .utf8) {
            buffer.append(string)
            processBuffer()
        }
    }

    @MainActor
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        Task {
            if let error {
                continuation.finish(throwing: error)
            } else if let errorData {
                let resError = XZError.netEerrorData(errorData, (task.response as? HTTPURLResponse)?.statusCode ?? -1)
                print("Connection closed with error==>\(resError.localizedDescription)")
                continuation.finish(throwing: resError)
            } else {
                continuation.finish()
            }
        }
    }

    private func processBuffer() {
        while let lineEnd = buffer.range(of: "\n") {
            let line = String(buffer[buffer.startIndex..<lineEnd.lowerBound])
            buffer.removeSubrange(buffer.startIndex..<lineEnd.upperBound)

            if line.starts(with: "data:") {
                let event = line.dropFirst(5).trimmingCharacters(in: .whitespaces)
                Task { @MainActor in
                    let str = event.replacingOccurrences(of: "\\n", with: "\n")
                    _ = continuation.yield(str)
                }
            }
        }
    }
}
