//
//  Constants.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

enum Constants {
    static var baseURL: URL {
        var urlString: String {
            #if DEBUG
                "https://api-test.payback.com/"
            #else
                "https://api.payback.com/"
            #endif
        }
        return URL(string: urlString)!
    }
}
