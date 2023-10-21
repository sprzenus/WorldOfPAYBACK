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
    func set(transactions: [TransactionModel])
}

@MainActor
final class TransactionsStore: ObservableObject {
    @Published var isLoading: Bool
    @Published var transactions: [TransactionModel]
    
    init(
        isLoading: Bool = false,
        transactions: [TransactionModel] = []
    ) {
        self.isLoading = isLoading
        self.transactions = transactions
    }
}

// MARK: - TransactionsUserInterface

extension TransactionsStore: TransactionsUserInterface {
    func set(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func set(transactions: [TransactionModel]) {
        self.transactions = transactions
    }
}
