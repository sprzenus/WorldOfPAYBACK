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
    @ViewBuilder
    func getViewInNavigationView() -> some View {
        NavigationView {
            getView()
        }
        .tabItem {
            Group {
                Image(systemName: "house")
                Text("Transactions")
            }
        }
    }
    
    private func getView() -> TransactionsView {
        let store = TransactionsStore()
        let presenter = TransactionsPresenter(
            userInterface: store,
            transactionsProvider: TransactionsProvider(),
            reachability: NetworkReachability()
        )
        let view = TransactionsView(
            presenter: presenter,
            store: store
        )
        return view
    }
}
