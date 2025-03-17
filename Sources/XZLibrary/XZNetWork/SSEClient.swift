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

    func stop() {
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
    private var buffer = ""

    init(continuation: AsyncThrowingStream<String, Error>.Continuation) {
        self.continuation = continuation
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let string = String(data: data, encoding: .utf8) {
            buffer.append(string)
            processBuffer()
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            Task { @MainActor in
                continuation.finish(throwing: error)
            }
        } else {
            Task { @MainActor in
                continuation.finish()
            }
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
