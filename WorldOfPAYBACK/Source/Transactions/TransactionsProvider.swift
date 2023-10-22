//
//  TransactionsProvider.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

protocol TransactionsProviderType: AnyObject {
    /// Returns result of fetching transactions. Throws only `CancellationError`.
    func getTransactions() async throws -> Result<TransactionsResponseModel, ApiServiceError>
}

final class TransactionsProvider {
    private let apiService: ApiService_Transactions
    
    init(apiService: ApiService_Transactions = ApiService()) {
        self.apiService = apiService
    }
}

// MARK: - TransactionsProviderType

extension TransactionsProvider: TransactionsProviderType {
    func getTransactions() async throws -> Result<TransactionsResponseModel, ApiServiceError> {
        // Uncomment the next line when backend is ready.
        // return try await apiService.getTransactions()
        
        try await Task.sleep(nanoseconds: UInt64(2e9))
        do {
            if let filePath = Bundle.main.path(forResource: "PBTransactions", ofType: "json"),
               let data = FileManager.default.contents(atPath: filePath)
            {
                let object = try JSONDecoder.paybackDefault.decode(TransactionsResponseModel.self, from: data)
                return .success(object)
            }
            return .failure(.transportError(NSError(domain: "me", code: 0)))
        } catch {
            return .failure(.transportError(error))
        }
    }
}
