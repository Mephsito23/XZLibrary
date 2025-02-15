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

    init(request: URLRequest) {
        self.request = request
    }

    func start() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let session = URLSession(configuration: .default)
            request.setValue("text/event-stream", forHTTPHeaderField: "Accept")

            task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.finish(throwing: error)
                    return
                }

                guard let data = data else {
                    continuation.finish(throwing: URLError(.badServerResponse))
                    return
                }

                let lines = String(decoding: data, as: UTF8.self).split(
                    separator: "\n")
                for line in lines {
                    if line.starts(with: "data:") {
                        let event = line.dropFirst(5).trimmingCharacters(
                            in: .whitespacesAndNewlines)
                        continuation.yield(event)
                    }
                }

                continuation.finish()
            }

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
        print("Connection closed.")
    }
}
