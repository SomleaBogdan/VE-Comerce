//
//  ReceiptRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import Foundation

protocol ReceiptService: AnyObject {
    func fetchReceiptsFor(user: User, completion: @escaping (Result<[Receipt], AppError>) -> Void)
    
    func create(receipt: Receipt, forUser: User, completion: @escaping (Result<Invoice, AppError>) -> Void)
    func delete(receipt: Receipt, completion: @escaping (Result<Bool, AppError>) -> Void)
}

class ReceiptRepository: ReceiptService {
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func fetchReceiptsFor(user: User, completion: @escaping (Result<[Receipt], AppError>) -> Void) {
        
    }
    
    func delete(receipt: Receipt, completion: @escaping (Result<Bool, AppError>) -> Void) {
        print("DELETE RECEIPT")
    }
    
    func create(receipt: Receipt, forUser: User, completion: @escaping (Result<Invoice, AppError>) -> Void) {
        print("CREATE RECEIPT")
    }
}
