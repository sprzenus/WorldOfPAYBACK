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
    func set(errorMessage: String?)
}

@MainActor
final class TransactionsStore: ObservableObject {
    @Published var isLoading: Bool
    @Published var transactions: [TransactionModel]
    @Published var errorMessage: String?
    
    init(
        isLoading: Bool = false,
        transactions: [TransactionModel] = [],
        errorMessage: String? = nil
    ) {
        self.isLoading = isLoading
        self.transactions = transactions
        self.errorMessage = errorMessage
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
    
    func set(errorMessage: String?) {
        self.errorMessage = errorMessage
    }
}
