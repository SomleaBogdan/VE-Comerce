//
//  AddExpensesViewModel.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

class AddExpensesViewModel: NSObject {

    var error: Observable<AppError?> = Observable(nil)
    var invoice: Observable<Invoice?> = Observable(nil)
    var receipt: Observable<Receipt?> = Observable(nil)
    
    private let invoiceService: InvoiceService
    private let receiptService: ReceiptService
    
    init(invoiceService: InvoiceService, receiptService: ReceiptService) {
        self.invoiceService = invoiceService
        self.receiptService = receiptService
    }
}
