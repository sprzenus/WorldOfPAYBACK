//
//  TransactionsProvider.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

protocol TransactionsProviderType: AnyObject {
    func getTransactions() async -> TransactionsResponseModel
}

final class TransactionsProvider {
    func getTransactions() async -> TransactionsResponseModel {
        
    }
}
