//
//  DashboardViewModel.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

class DashboardViewModel: NSObject {
    
    var error: Observable<AppError?> = Observable(nil)
    var invoices: Observable<[Invoice]?> = Observable(nil)
    var receipts: Observable<[Receipt]?> = Observable(nil)
    
    private let invoiceService: InvoiceService
    private let receiptService: ReceiptService
    
    init(invoiceService: InvoiceService, receiptService: ReceiptService) {
        self.invoiceService = invoiceService
        self.receiptService = receiptService
    }
}
