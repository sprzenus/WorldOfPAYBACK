//
//  ApiServiceError.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

enum ApiServiceError: Error {
    case transportError(Error)
    case clientSideError(Data)
    case serverSideError(Data)
    case unexpectedError(Data)
}
