//
//  TransactionsPresenter.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

@MainActor
protocol TransactionsPresenterInterface: AnyObject {
    func prepareView()
}

@MainActor
final class TransactionsPresenter {
    private weak var userInterface: TransactionsUserInterface?
    private let transactionsProvider: TransactionsProviderType
    
    init(
        userInterface: TransactionsUserInterface?,
        transactionsProvider: TransactionsProviderType
    ) {
        self.userInterface = userInterface
        self.transactionsProvider = transactionsProvider
    }
}

// MARK: - TransactionsPresenterInterface

extension TransactionsPresenter: TransactionsPresenterInterface {
    func prepareView() {
        userInterface?.set(isLoading: true)
        userInterface?.set(errorMessage: nil)
        Task {
            try? await fetchData()
            userInterface?.set(isLoading: false)
        }
    }
}

// MARK: - Private

extension TransactionsPresenter {
    private func fetchData() async throws {
        let result = try await transactionsProvider.getTransactions()
        switch result {
        case let .success(response):
            let sortedTransactions = response.items.sorted { lhs, rhs in
                lhs.transactionDetail.bookingDate > rhs.transactionDetail.bookingDate
            }
            userInterface?.set(transactions: sortedTransactions)
        case let .failure(error):
            userInterface?.set(errorMessage: String(localized: LocalizedStringResource("transactions_error_generic")))
            print("Got an error: \(error)")
        }
    }
}
