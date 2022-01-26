//
//  ReceiptRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import Foundation
import UIKit

protocol ReceiptService: AnyObject {
    func fetchUserReceipts(completion: @escaping (Result<[Receipt], AppError>) -> Void)
    func storeReceipt(image: UIImage) throws -> String
    func create(receipt: Receipt, completion: @escaping (Result<Receipt, AppError>) -> Void)
    func delete(receipt: Receipt, completion: @escaping (Result<Bool, AppError>) -> Void)
}

class ReceiptRepository: ReceiptService {
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func fetchUserReceipts(completion: @escaping (Result<[Receipt], AppError>) -> Void) {
        let receiptStore = ReceiptStore(user: user)
        do {
            let receipts = try receiptStore.getUserReceipts()
            completion(.success(receipts))
        } catch let exception {
            if let err = exception as? AppError {
                completion(.failure(err))
            }
        }
    }
    
    func delete(receipt: Receipt, completion: @escaping (Result<Bool, AppError>) -> Void) {
        print("DELETE RECEIPT")
    }
    
    func create(receipt: Receipt, completion: @escaping (Result<Receipt, AppError>) -> Void) {
        let receiptStore = ReceiptStore(receipt: receipt, user: user)
        do {
            let storedReceipt = try receiptStore.storeReceipt()
            completion(.success(storedReceipt))
        } catch let exception {
            if let err = exception as? AppError {
                completion(.failure(err))
            }
        }
    }
    
    func storeReceipt(image: UIImage) throws -> String {
        let imageRepository = ImageRepository(user: user)
        let fileName = try imageRepository.store(image: image, forExpense: .receipt)
        return fileName
    }
}
