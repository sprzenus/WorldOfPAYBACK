//
//  TransactionDetailsView.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 22/10/2023.
//

import SwiftUI

protocol TransactionDetailsPresenterInterface: AnyObject {}

struct TransactionDetailsView: View {
    private let presenter: TransactionDetailsPresenterInterface?
    @ObservedObject private var store: TransactionDetailsStore
    
    init(
        presenter: TransactionDetailsPresenterInterface?,
        store: TransactionDetailsStore
    ) {
        self.presenter = presenter
        self.store = store
    }
    
    var body: some View {
        VStack {
            Text(store.transaction.partnerDisplayName)
                .font(.title)
            Text(store.transaction.transactionDetail.description ?? "")
                .font(.body)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TransactionDetailsView(
        presenter: nil,
        store: .init(transaction: TransactionModel(
            partnerDisplayName: "This is the partner name",
            alias: .init(reference: "123"),
            category: 1,
            transactionDetail: .init(
                description: "some description",
                bookingDate: Date(),
                value: .init(amount: 146, currency: "PLN")
            )
        ))
    )
}
