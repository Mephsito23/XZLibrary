//
//  NWPathMonitor+Combine.swift
//  Reader
//
//  Created by Mephisto on 2021/12/12.
//

import Combine
import Foundation
import Network
import XZCore

// MARK: - NWPathMonitor Subscription

extension NWPathMonitor {
    public class NetworkStatusSubscription<S: Subscriber>: Subscription
    where S.Input == NWPath.Status, S: Sendable {
        private let subscriber: S?

        private let monitor: NWPathMonitor
        private let queue: DispatchQueue

        init(
            subscriber: S,
            monitor: NWPathMonitor,
            queue: DispatchQueue
        ) {
            self.subscriber = subscriber
            self.monitor = monitor
            self.queue = queue
        }

        public func request(_ demand: Subscribers.Demand) {
            let subscriber = self.subscriber
            let monitor = self.monitor
            let queue = self.queue
            let pathUpdateHandler: @Sendable (NWPath) -> Void = { path in
                _ = subscriber?.receive(path.status)
            }
            monitor.pathUpdateHandler = pathUpdateHandler

            monitor.start(queue: queue)
        }

        public func cancel() {
            // 3
            monitor.cancel()
        }
    }
}

// MARK: - NWPathMonitor Publisher

extension NWPathMonitor {
    public struct NetworkStatusPublisher: Publisher {
        // 1
        public typealias Output = NWPath.Status
        public typealias Failure = Never

        // 2
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue

        init(
            monitor: NWPathMonitor,
            queue: DispatchQueue
        ) {
            self.monitor = monitor
            self.queue = queue
        }

        public func receive<S>(subscriber: S)
        where
            S: Subscriber & Sendable, Never == S.Failure,
            NWPath.Status == S.Input
        {
            // 3
            let subscription = NetworkStatusSubscription(
                subscriber: subscriber,
                monitor: monitor,
                queue: queue
            )

            subscriber.receive(subscription: subscription)
        }
    }

    // 4
    public func publisher(
        queue: DispatchQueue
    )
        -> NWPathMonitor.NetworkStatusPublisher
    {
        return NetworkStatusPublisher(
            monitor: self,
            queue: queue
        )
    }
}
