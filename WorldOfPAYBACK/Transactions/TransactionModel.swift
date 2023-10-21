//
//  TransactionModel.swift
//  WorldOfPAYBACK
//
//  Created by Bartłomiej Świerad on 21/10/2023.
//

import Foundation

struct TransactionsResponseModel: Codable {
    let items: [TransactionModel]
}

struct TransactionModel: Codable, Identifiable {
    var id: String { alias.reference }
    
    let partnerDisplayName: String
    let alias: Alias
    let category: Int
    let transactionDetail: Details
    
    struct Alias: Codable {
        let reference: String
    }
    
    struct Details: Codable {
        let description: String?
        let bookingDate: Date // "2022-07-24T10:59:05+0200"
        let value: Price
    }
    
    struct Price: Codable {
        let amount: Double
        let currency: String
    }
}

/*
 {
     "partnerDisplayName" : "REWE Group",
     "alias" : {
         "reference" : "795357452000810"
     },
     "category" : 1,
     "transactionDetail" : {
         "description" : "Punkte sammeln",
         "bookingDate" : "2022-07-24T10:59:05+0200",
         "value" : {
             "amount" : 124,
             "currency" : "PBP"
         }
     }
 },
 */
