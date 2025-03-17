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
    private var delegate: SSEClientDelegate?

    init(request: URLRequest) {
        self.request = request
    }

    func start() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let sessionConfig = URLSessionConfiguration.default
            session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            request.setValue("text/event-stream", forHTTPHeaderField: "Accept")

            // 创建代理对象
            delegate = SSEClientDelegate(continuation: continuation)
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
        session = nil
        delegate = nil
        print("Connection closed.")
    }
}

// 创建一个继承自 NSObject 的代理类
final class SSEClientDelegate: NSObject, URLSessionDataDelegate, @unchecked Sendable {
    private var continuation: AsyncThrowingStream<String, Error>.Continuation
    private var dataBuffer = Data()

    init(continuation: AsyncThrowingStream<String, Error>.Continuation) {
        self.continuation = continuation
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dataBuffer.append(data)
        processBuffer()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            continuation.finish(throwing: error)
        } else {
            continuation.finish()
        }
    }

    private func processBuffer() {
        let bufferString = String(decoding: dataBuffer, as: UTF8.self)
        let lines = bufferString.split(separator: "\n")

        var remainingData = ""
        for line in lines {
            if line.starts(with: "data:") {
                let event = line.dropFirst(5).trimmingCharacters(in: .whitespacesAndNewlines)
                remainingData += "\(event)\n"
            }
        }

        // Yield events to the stream
        for event in remainingData.split(separator: "\n") {
            continuation.yield(String(event))
        }

        // Update buffer with remaining incomplete data
        if let lastLineIndex = bufferString.lastIndex(of: "\n") {
            let remainingIndex = bufferString.index(after: lastLineIndex)
            dataBuffer = Data(bufferString[remainingIndex...].utf8)
        } else {
            dataBuffer = Data()
        }
    }
}
