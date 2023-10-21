//
//  ApiService_Transactions.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

protocol ApiService_Transactions {
    /// Fetches transactions from backend server. Throws only CancellationError if the task was cancelled.
    func getTransactions() async throws -> Result<TransactionsResponseModel, ApiServiceError>
}

extension ApiService: ApiService_Transactions {
    func getTransactions() async throws -> Result<TransactionsResponseModel, ApiServiceError> {
        let urlRequest = URLRequest(url: url(for: .transactions))
        return try await request(urlRequest)
    }
}
