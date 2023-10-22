//
//  TransactionDetailsStore.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 22/10/2023.
//

import Foundation

final class TransactionDetailsStore: ObservableObject {
    @Published private(set) var transaction: TransactionModel
    
    init(transaction: TransactionModel) {
        self.transaction = transaction
    }
}
