//
//  ReceiptStore.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 26.01.2022.
//

import UIKit
import CoreData

class ReceiptStore: NSObject {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var receipt: Receipt?
    private var user: User?
    
    convenience init(receipt: Receipt, user: User) {
        self.init()
        self.receipt = receipt
        self.user = user
    }
    
    convenience init(user: User) {
        self.init()
        self.user = user
    }
    
    func storeReceipt() throws -> Receipt {
        guard let receiptToStore = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: appDelegate.persistentContainer.viewContext) as? Receipt else {
            throw AppError.storageError
        }
        guard let receipt = receipt, let user = user else {
            throw AppError.storageError
        }
        
        receiptToStore.currency = receipt.currency
        receiptToStore.imagePath = receipt.imagePath
        receiptToStore.paymentDate = receipt.paymentDate
        receiptToStore.total = receipt.total
        receiptToStore.user = user
        
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            throw AppError.storageError
        }
        return receiptToStore
    }
    
    func getUserReceipts() throws -> [Receipt] {
        guard let user = user else {
            throw AppError.storageError
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Receipt>(entityName: "Receipt")
        fetchRequest.predicate = NSPredicate(format: "user.email == %@", user.email)
        guard let receipts = try? context.fetch(fetchRequest) else {
            throw AppError.storageError
        }
        return receipts
    }
}
