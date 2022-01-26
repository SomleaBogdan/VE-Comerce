//
//  InvoiceStore.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 26.01.2022.
//

import UIKit
import CoreData

class InvoiceStore: NSObject {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var invoice: Invoice?
    private var user: User?
    
    convenience init(invoice: Invoice, user: User) {
        self.init()
        self.invoice = invoice
        self.user = user
    }
    
    convenience init(user: User) {
        self.init()
        self.user = user
    }
    
    func storeInvoice() throws -> Invoice {
        guard let invoiceToStore = NSEntityDescription.insertNewObject(forEntityName: "Invoice", into: appDelegate.persistentContainer.viewContext) as? Invoice else {
            throw AppError.storageError
        }
        guard let invoice = invoice, let user = user else {
            throw AppError.storageError
        }
        
        invoiceToStore.currency = invoice.currency
        invoiceToStore.imagePath = invoice.imagePath
        invoiceToStore.isPaid = invoice.isPaid
        invoiceToStore.paymentDate = invoice.paymentDate
        invoiceToStore.issueDate = invoice.issueDate
        invoiceToStore.total = invoice.total
        invoiceToStore.user = user
        
        print("STORED INVOICE => \(invoice)")
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            throw AppError.storageError
        }
        return invoiceToStore
    }
    
    func getUserInvoices() throws -> [Invoice] {
        guard let user = user else {
            throw AppError.storageError
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Invoice>(entityName: "Invoice")
        fetchRequest.predicate = NSPredicate(format: "user.email == %@", user.email)
        guard let invoices = try? context.fetch(fetchRequest) else {
            throw AppError.storageError
        }
        return invoices
    }
}
