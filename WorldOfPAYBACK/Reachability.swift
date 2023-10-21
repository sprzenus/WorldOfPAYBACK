//
//  Reachability.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation
import Network
import Combine

protocol ReachabilityInterface: AnyObject {
    var networkAvailabilityChangedPublisher: AnyPublisher<Void, Never> { get }
    func isNetworkAvailable() -> Bool
}

final class NetworkReachability: ReachabilityInterface {
    private let pathMonitor: NWPathMonitor
    
    private let pathSubject: CurrentValueSubject<NWPath, Never>
    let networkAvailabilityChangedPublisher: AnyPublisher<Void, Never>
    
    private var task: Task<Void, Never>?
    
    init() {
        pathMonitor = NWPathMonitor()
        pathSubject = .init(pathMonitor.currentPath)
        networkAvailabilityChangedPublisher = pathSubject
            .removeDuplicates()
            .map { _ in }
            .share()
            .eraseToAnyPublisher()
        
        task = Task { @MainActor in
            for await path in pathMonitor {
                pathSubject.send(path)
                print(path.status)
            }
        }
    }
    
    deinit {
        task?.cancel()
    }
    
    func isNetworkAvailable() -> Bool {
        pathSubject.value.status == .satisfied
    }
}
