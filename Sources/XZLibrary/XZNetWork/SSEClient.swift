//
//  File.swift
//  XZLibrary
//
//  Created by Mephisto on 2025/2/15.
//

import Foundation

public actor SSEClient {
    private var request: URLRequest

    init(request: URLRequest) {
        self.request = request
    }

    func start() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                let session = URLSession(configuration: .default)
                request.setValue(
                    "text/event-stream", forHTTPHeaderField: "Accept")

                do {
                    let (stream, _) = try await session.bytes(for: request)

                    for try await line in stream.lines {
                        if line.starts(with: "data:") {
                            let event = line.dropFirst(5).trimmingCharacters(
                                in: .whitespacesAndNewlines)
                            continuation.yield(event)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
