//
//  AddExpensesFormField.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import Foundation
import UIKit

enum AddExpensesFormFieldType {
    case image, currency, isPaid, issueDate, paymentDate, total
    var title: String? {
        switch self {
        case .image:
            return "Image"
        case .currency:
            return "Currency"
        case .isPaid:
            return "Is Paid?"
        case .issueDate:
            return "Issue Date"
        case .paymentDate:
            return "Payment Date"
        case .total:
            return "Total"
        }
    }
    
    var placeholder: String? {
        switch self {
        case .total:
            return "0.00"
        default:
            return ""
        }
    }
    
    var keyboardType: UIKeyboardType? {
        switch self {
        case .total:
            return .decimalPad
        default:
            return .default
        }
    }
    
    var key: String {
        switch self {
        case .image:
            return "image"
        case .currency:
            return "currency"
        case .isPaid:
            return "is_paid"
        case .issueDate:
            return "issue_date"
        case .paymentDate:
            return "payment_date"
        case .total:
            return "total"
        }
    }
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
    
    mutating func updateAt(index: Int, value: Any) {
        self[index].value = value
    }
    
    var asDictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        for field in self {
            switch field.fieldType {
            case .currency, .isPaid, .image:
                if let key = field.fieldType?.key {
                    dictionary[key] = field.value
                }
            case .issueDate, .paymentDate:
                if let key = field.fieldType?.key {
                    if let dateValue = field.value as? Date {
                        let dateFormatter = ISO8601DateFormatter()
                        let stringDate = dateFormatter.string(from: dateValue)
                        dictionary[key] = stringDate
                    }
                }
            case .total:
                if let key = field.fieldType?.key, let doubleStr = field.value as? String {
                    dictionary[key] = Double(doubleStr)
                }
            default:
                break
            }
        }
        return dictionary
    }
}
