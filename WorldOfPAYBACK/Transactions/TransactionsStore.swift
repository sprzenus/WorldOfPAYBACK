//
//  TransactionsStore.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

@MainActor
protocol TransactionsUserInterface: AnyObject {
    func set(isLoading: Bool)
}

@MainActor
final class TransactionsStore: ObservableObject {
    @Published var isLoading: Bool
    
    init(isLoading: Bool = false) {
        self.isLoading = isLoading
    }
}

// MARK: - TransactionsUserInterface

extension TransactionsStore: TransactionsUserInterface {
    func set(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
