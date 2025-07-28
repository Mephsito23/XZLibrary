//
//  File.swift
//  XZLibrary
//
//  Created by Mephisto on 2025/2/15.
//

import Foundation
import XZCore

public actor SSEClient {
    private var request: URLRequest
    private var task: URLSessionDataTask?
    private var session: URLSession?
    private weak var delegate: SSEClientDelegate?

    public init(request: URLRequest) {
        self.request = request
    }

    public func start() -> AsyncThrowingStream<String, Error> {
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
    private var continuation: AsyncThrowingStream<String, Error>.Continuation
    private var errorData: Data?
    private var buffer = ""
    private var rawDataBuffer = Data()

    init(continuation: AsyncThrowingStream<String, Error>.Continuation) {
        self.continuation = continuation
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let httpResponse = dataTask.response as? HTTPURLResponse,
            !(200...299).contains(httpResponse.statusCode)
        {
            errorData = data  // 缓存非 2xx 响应的数据
            return
        }
        parseBuffer(for: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        Task { @MainActor in
            if let error {
                continuation.finish(throwing: error)
                return
            }

            if let errorData = errorData {
                let statusCode = (task.response as? HTTPURLResponse)?.statusCode ?? -1
                let serverError = XZError.netEerrorData(errorData, statusCode)
                print("statusCode==>\(serverError.localizedDescription)")
                continuation.finish(throwing: serverError)
                return
            }
            continuation.finish()
        }
    }

    private func parseBuffer(for data: Data) {
        rawDataBuffer.append(data)
        if let string = String(data: rawDataBuffer, encoding: .utf8) {
            rawDataBuffer.removeAll()
            print("SSE RECEIVE DATA:  \(string)")
            buffer.append(string)
            processBuffer()
        }
    }

    private func processBuffer() {
        while let lineEnd = buffer.range(of: "\n") {
            let line = String(buffer[buffer.startIndex..<lineEnd.lowerBound])
            buffer.removeSubrange(buffer.startIndex..<lineEnd.upperBound)

            if line.starts(with: "data:") {
                let event = line.dropFirst(5).trimmingCharacters(in: .whitespacesAndNewlines)
                Task { @MainActor in
                    _ = continuation.yield(event)
                }
            }
        }
    }
}
