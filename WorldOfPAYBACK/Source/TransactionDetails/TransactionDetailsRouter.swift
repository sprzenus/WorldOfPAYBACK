//
//  TransactionDetailsRouter.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 22/10/2023.
//

import SwiftUI

@MainActor
final class TransactionDetailsRouter {
    private let transaction: TransactionModel
    
    init(transaction: TransactionModel) {
        self.transaction = transaction
    }
    
    func getView() -> TransactionDetailsView {
        let store = TransactionDetailsStore(transaction: transaction)
        return TransactionDetailsView(presenter: nil, store: store)
    }
}
