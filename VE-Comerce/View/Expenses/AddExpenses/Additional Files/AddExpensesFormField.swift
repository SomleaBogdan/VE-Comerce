//
//  AddExpensesFormField.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import Foundation

enum AddExpensesFormFieldType {
    case image, currency, isPaid, issueDate, paymentDate, total
}

class AddExpensesFormField: NSObject {
    
    static let paymentDateField = AddExpensesFormField(type: .paymentDate)
    
    static let asReceiptFields = [AddExpensesFormField(type: .paymentDate),
                                  AddExpensesFormField(type: .total),
                                  AddExpensesFormField(type: .currency),
                                  AddExpensesFormField(type: .image)]
    
    static var asInvoiceFields = [AddExpensesFormField(type: .issueDate),
                                  AddExpensesFormField(type: .total),
                                  AddExpensesFormField(type: .currency),
                                  AddExpensesFormField(type: .isPaid),
                                  AddExpensesFormField(type: .image)]
    
    var fieldType: AddExpensesFormFieldType?
    var value: Any?
    
    override init() {
        super.init()
        self.fieldType = nil
        self.value = nil
    }
    
    convenience init(type: AddExpensesFormFieldType) {
        self.init()
        self.fieldType = type
    }
}

extension Array where Element == AddExpensesFormField {
    
    mutating func updateAt(index: Int, value: String) {
        self[index].value = value
    }
}
