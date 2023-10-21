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
        List {
            ForEach(store.transactions) { transaction in
                TransactionRow(
                    partnerDisplayName: transaction.partnerDisplayName,
                    bookingDate: transaction.transactionDetail.bookingDate,
                    description: transaction.transactionDetail.description,
                    priceAmount: transaction.transactionDetail.value.amount,
                    priceCurrency: transaction.transactionDetail.value.currency
                )
            }
        }
        .overlay {
            if store.isLoading {
                ZStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                    Color.black
                        .ignoresSafeArea(edges: [.horizontal, .top])
                        .opacity(0.2)
                }
            }
        }
        .navigationTitle("Transactions")
        .tabItem {
            Group {
                Image(systemName: "house")
                Text("Transactions")
            }
        }
        .onAppear {
            presenter?.prepareView()
        }
    }
}

private struct TransactionRow: View {
    let partnerDisplayName: String
    let bookingDate: Date
    let description: String?
    let priceAmount: Double
    let priceCurrency: String
    
    var body: some View {
        VStack(alignment: .leading) {
                Text(partnerDisplayName)
                    .font(.headline)
                Text(bookingDate.formatted(date: .abbreviated, time: .standard))
                    .font(.caption)
                    .opacity(0.8)
                    .multilineTextAlignment(.leading)
            if let description {
                Text(description)
                    .font(.subheadline)
                    .opacity(0.9)
                    .padding(.top, 4)
            }
            
            Text(priceAmount.formatted(.currency(code: priceCurrency)))
                .font(Font.title3.bold())
                .padding(.top, 4)
        }
    }
}

#Preview {
    TabView {
        TransactionsView(
            presenter: nil,
            store: TransactionsStore(
                isLoading: true,
                transactions: [
                    .init(
                        partnerDisplayName: "One title",
                        alias: .init(reference: "ref"),
                        category: 2,
                        transactionDetail: .init(
                            description: "Description",
                            bookingDate: Date(),
                            value: .init(amount: 123, currency: "PLN")
                        )
                    ),
                ]
            )
        )
    }
}
