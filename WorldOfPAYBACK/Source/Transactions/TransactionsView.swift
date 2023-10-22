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
    @State private var filterByCategory: Int?
    
    private var transactions: [TransactionModel] {
        if let filterByCategory {
            store.transactions.filter { $0.category == filterByCategory }
        } else {
            store.transactions
        }
    }
    
    private var totalPrice: TransactionModel.Price? {
        let transactions = transactions
        guard let currency = transactions.first?.transactionDetail.value.currency else { return nil }
        let amount = transactions
            .filter { $0.transactionDetail.value.currency == currency } // Just for safety
            .map(\.transactionDetail.value.amount)
            .reduce(0.0, +)
        return .init(amount: amount, currency: currency)
    }
    
    init(
        presenter: TransactionsPresenterInterface?,
        store: TransactionsStore
    ) {
        self.presenter = presenter
        self.store = store
    }
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                NavigationLink {
                    TransactionDetailsRouter(transaction: transaction)
                        .getView()
                    // This should be done by the router, however I've got no time to refactor this at the moment.
                } label: {
                    TransactionRow(
                        partnerDisplayName: transaction.partnerDisplayName,
                        bookingDate: transaction.transactionDetail.bookingDate,
                        description: transaction.transactionDetail.description,
                        priceAmount: transaction.transactionDetail.value.amount,
                        priceCurrency: transaction.transactionDetail.value.currency
                    )
                }
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            if let totalPrice {
                totalPriceView(price: totalPrice)
            }
        })
        .overlay {
            if store.isLoading {
                loadingOverlay
            } else if let errorMessage = store.errorMessage,
                      store.transactions.isEmpty
            {
                errorView(message: errorMessage)
            }
        }
        .overlay {
            if !store.isInternetReachable {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "wifi.slash")
                        Text("We've lost internet connection.")
                            .font(.callout)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    Spacer()
                }
            }
        }
        .toolbar(content: {
            TransactionsToolbar(
                categories: store.categories,
                filterByCategory: $filterByCategory
            )
        })
        .navigationTitle("Transactions")
        .onAppear {
            presenter?.prepareView()
        }
    }
    
    @ViewBuilder
    private func totalPriceView(price: TransactionModel.Price) -> some View {
        HStack {
            Text("Total")
                .fontWeight(.light)
            Spacer()
            Text(price.amount.formatted(.currency(code: price.currency)))
                .bold()
        }
        .font(.title)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(.thinMaterial)
    }
    
    @ViewBuilder
    private var loadingOverlay: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(.circular)
            Color.black
                .ignoresSafeArea(edges: [.horizontal, .top])
                .opacity(0.2)
        }
    }
    
    @ViewBuilder
    private func errorView(message errorMessage: String) -> some View {
        VStack(spacing: 16) {
            Text("An error occured")
                .font(.headline)
            Text(errorMessage)
                .font(.body)
            
            Button {
                presenter?.prepareView()
            } label: {
                Text("Retry")
            }
        }
    }
}

// MARK: - TransactionsToolbar

private struct TransactionsToolbar: ToolbarContent {
    let categories: [Int]
    @Binding var filterByCategory: Int?
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button {
                    filterByCategory = nil
                } label: {
                    Text("Clear filters")
                }
                ForEach(categories, id: \.self) { category in
                    Button {
                        filterByCategory = category
                    } label: {
                        HStack {
                            Text("\(category)")
                            Spacer()
                            if filterByCategory == category {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                if filterByCategory == nil {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                } else {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
    }
}

// MARK: - TransactionRow

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
            
            HStack {
                Spacer()
                Text(priceAmount.formatted(.currency(code: priceCurrency)))
                    .font(Font.title3.bold())
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationView {
        TransactionsView(
            presenter: nil,
            store: TransactionsStore(
                isLoading: false,
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
                ],
                categories: [1, 2, 3],
                errorMessage: "generic error message",
                isInternetReachable: true
            )
        )
    }
}
