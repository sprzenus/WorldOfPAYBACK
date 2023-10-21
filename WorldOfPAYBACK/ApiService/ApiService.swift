//
//  ApiService.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

final class ApiService {
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    init(
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .paybackDefault
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - Internal
    
    func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> Result<T, ApiServiceError> {
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
    
    func url(for endpoint: Endpoint) -> URL {
        Constants.baseURL.appendingPathComponent(endpoint.rawValue)
    }
}
