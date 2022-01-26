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
    
    //MARK: - Invoice Methods
    func storeInvoiceFrom(dictionary: [String: Any]) throws {
        var fileName: String?
        if let image = dictionary["image"] as? UIImage {
            //Save image file
            fileName = try? invoiceService.storeInvoice(image: image)
        }
        
        var invoiceDictionary = dictionary
        invoiceDictionary.removeValue(forKey: "image")
        if let fileName = fileName {
            invoiceDictionary["image_path"] = fileName
        }
        
        let invoice: Invoice = try invoiceDictionary.decoded()
        
        let validated = invoice.validated()
        switch validated {
        case .invalid(let errorString):
            self.error.value = AppError(description: errorString)
        case .success:
            performInvoiceSave(invoice: invoice)
        default:
            break
        }
    }
    
    func performInvoiceSave(invoice: Invoice) {
        invoiceService.create(invoice: invoice) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let invoice):
                self.invoice.value = invoice
            case .failure(let error):
                self.error.value = AppError(description: error.localizedString ?? "Something went wrong. Try again later.")
            }
        }
    }
    
    
    //MARK: - Receipt Methods
    func storeReceiptFrom(dictionary: [String: Any]) throws {
        var fileName: String?
        if let image = dictionary["image"] as? UIImage {
            //Save image file
            fileName = try? receiptService.storeReceipt(image: image)
        }
        
        var receiptDictionary = dictionary
        receiptDictionary.removeValue(forKey: "image")
        if let fileName = fileName {
            receiptDictionary["image_path"] = fileName
        }
        
        let receipt: Receipt = try receiptDictionary.decoded()
        
        let validated = receipt.validated()
        switch validated {
        case .invalid(let errorString):
            self.error.value = AppError(description: errorString)
        case .success:
            performReceiptSave(receipt: receipt)
        default:
            break
        }
    }
    
    private func performReceiptSave(receipt: Receipt) {
        receiptService.create(receipt: receipt) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receipt):
                self.receipt.value = receipt
            case .failure(let error):
                self.error.value = AppError(description: error.localizedString ?? "Something went wrong. Try again later.")
            }
        }
    }
}
