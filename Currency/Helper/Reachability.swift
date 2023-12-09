//
//  Reachability.swift
//  Currency
//
//  Created by Shrouk Yasser on 09/12/2023.
//

import Foundation
import Network

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        let monitor = NWPathMonitor()

        var isConnected = false
        let semaphore = DispatchSemaphore(value: 0)

        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

        _ = semaphore.wait(timeout: .now() + 1)

        return isConnected
    }
}
