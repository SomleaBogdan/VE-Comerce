//
//  InvoiceRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

protocol InvoiceService: AnyObject {
    //Get All For User
    func fetchUserInvoices(completion: @escaping (Result<[Invoice], AppError>) -> Void)
    func storeInvoice(image: UIImage) throws -> String
    func create(invoice: Invoice, completion: @escaping (Result<Invoice, AppError>) -> Void)
    func delete(invoice: Invoice, completion: @escaping (Result<Bool, AppError>) -> Void)
}

class InvoiceRepository: InvoiceService {
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func fetchUserInvoices(completion: @escaping (Result<[Invoice], AppError>) -> Void) {
        let invoiceStore = InvoiceStore(user: user)
        do {
            let invoices = try invoiceStore.getUserInvoices()
            completion(.success(invoices))
        } catch let exception {
            if let err = exception as? AppError {
                completion(.failure(err))
            }
        }
    }
    
    func delete(invoice: Invoice, completion: @escaping (Result<Bool, AppError>) -> Void) {
        print("DELETE INVOICE")
    }
    
    func create(invoice: Invoice, completion: @escaping (Result<Invoice, AppError>) -> Void) {
        let invoiceStore = InvoiceStore(invoice: invoice, user: user)
        do {
            let storedInvoice = try invoiceStore.storeInvoice()
            completion(.success(storedInvoice))
        } catch let exception {
            if let err = exception as? AppError {
                completion(.failure(err))
            }
        }
    }
    
    func storeInvoice(image: UIImage) throws -> String {
        let imageRepository = ImageRepository(user: user)
        let fileName = try imageRepository.store(image: image, forExpense: .invoice)
        return fileName
    }
}
