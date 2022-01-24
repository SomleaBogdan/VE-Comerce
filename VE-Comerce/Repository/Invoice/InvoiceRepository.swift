//
//  InvoiceRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

protocol InvoiceService: AnyObject {
    //Get All For User
    func fetchInvoicesFor(user: User, completion: @escaping (Result<[Invoice], AppError>) -> Void)
    
    func create(invoice: Invoice, forUser: User, completion: @escaping (Result<Invoice, AppError>) -> Void)
    func delete(invoice: Invoice, completion: @escaping (Result<Bool, AppError>) -> Void)
}

class InvoiceRepository: InvoiceService {
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func fetchInvoicesFor(user: User, completion: @escaping (Result<[Invoice], AppError>) -> Void) {
        print("GET INVOICES")
    }
    
    func delete(invoice: Invoice, completion: @escaping (Result<Bool, AppError>) -> Void) {
        print("DELETE INVOICE")
    }
    
    func create(invoice: Invoice, forUser: User, completion: @escaping (Result<Invoice, AppError>) -> Void) {
        print("CREATE INVOICE")
    }
}
