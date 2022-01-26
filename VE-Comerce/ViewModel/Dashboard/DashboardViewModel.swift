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
    
    func fetchUserInvoices() {
        invoiceService.fetchUserInvoices { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let invoices):
                self.invoices.value = invoices
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    func fetchUserReceipts() {
        receiptService.fetchUserReceipts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receipts):
                self.receipts.value = receipts
            case .failure(let error):
                self.error.value = error
            }
        }
    }
}
