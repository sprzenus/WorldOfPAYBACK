//
//  TransactionsRouter.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation
import SwiftUI

@MainActor
final class TransactionsRouter {
    func getView() -> TransactionsView {
        let store = TransactionsStore()
        let presenter = TransactionsPresenter(userInterface: store)
        let view = TransactionsView(presenter: presenter, store: store)
        return view
    }
}
