//
//  TransactionsView.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import SwiftUI

struct TransactionsView: View {
    private let presenter: TransactionsPresenterInterface?
    @ObservedObject private var store: TransactionsStore
    
    init(
        presenter: TransactionsPresenterInterface?,
        store: TransactionsStore
    ) {
        self.presenter = presenter
        self.store = store
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    TransactionsView(
        presenter: nil, 
        store: TransactionsStore(
            isLoading: true
        )
    )
}
