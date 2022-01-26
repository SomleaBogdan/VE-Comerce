//
//  Expense.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 26.01.2022.
//

import Foundation

protocol Expense {
    
    var image: String? { get }
    var currency: String { get }
    var totalWithCurrency: String { get }
    var isPaid: Bool { get }
    var issueDateString: String? { get }
    var paymentDateString: String? { get }
    
}
