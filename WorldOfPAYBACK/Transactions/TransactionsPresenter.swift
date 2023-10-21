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
    
    init(userInterface: TransactionsUserInterface?) {
        self.userInterface = userInterface
    }
    
}

// MARK: - TransactionsPresenterInterface

extension TransactionsPresenter: TransactionsPresenterInterface {
    func prepareView() {
        userInterface?.set(isLoading: true)
        Task {
            await fetchData()
            userInterface?.set(isLoading: false)
        }
    }
}

// MARK: - Private

extension TransactionsPresenter {
    private func fetchData() async {
        try? await Task.sleep(nanoseconds: UInt64(2e9))
    }
}
