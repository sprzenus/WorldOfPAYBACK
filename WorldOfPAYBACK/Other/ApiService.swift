//
//  ApiService.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

protocol ApiService_Transactions {
    /// Fetches transactions from backend server. Throws only CancellationError if the task was cancelled.
    func getTransactions() async throws -> Result<TransactionsResponseModel, ApiServiceError>
}

final class ApiService {
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
}

// MARK: - ApiService_Transactions

extension ApiService: ApiService_Transactions {
    func getTransactions() async throws -> Result<TransactionsResponseModel, ApiServiceError> {
        let urlRequest = URLRequest(url: url(for: .transactions))
        return try await request(urlRequest)
    }
}

// MARK: - Private

extension ApiService {
    private func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> Result<T, ApiServiceError> {
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            let statusCode = (response as! HTTPURLResponse).statusCode
            switch statusCode {
            case 200...299:
                let object = try jsonDecoder.decode(T.self, from: data)
                return .success(object)
            case 400...499:
                return .failure(.clientSideError(data))
            case 500...599:
                return .failure(.serverSideError(data))
            default:
                assertionFailure("Unexpected response with status code: \(statusCode)")
                return .failure(.unexpectedError(data))
            }
        } catch let error as CancellationError {
            throw error
        } catch {
            return .failure(.transportError(error))
        }
    }
    
    private func url(for endpoint: Endpoint) -> URL {
        Constants.baseURL.appendingPathComponent(endpoint.rawValue)
    }
}

enum ApiServiceError: Error {
    case transportError(Error)
    case clientSideError(Data)
    case serverSideError(Data)
    case unexpectedError(Data)
}

enum Endpoint: String {
    case transactions
}
