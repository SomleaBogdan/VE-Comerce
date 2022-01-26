//
//  ImageRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 26.01.2022.
//

import UIKit

protocol ImageService: AnyObject {
    func store(image: UIImage, forExpense type: AddExpenseType) throws -> String
}

class ImageRepository: ImageService {

    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func store(image: UIImage, forExpense type: AddExpenseType) throws -> String {
        let directory: String = {
            switch type {
            case .receipt:
                return "receipts"
            case .invoice:
                return "invoices"
            }
        }()

        guard let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw AppError.storageError
        }
        let directoryPath = docUrl.appendingPathComponent(directory)
        let timestamp = Int(Date().timeIntervalSince1970)
        let fullFileName = "\(timestamp).jpg"
        let fileUrl = directoryPath.appendingPathComponent(fullFileName)
        do {
            try FileManager.default.createDirectory(atPath: directoryPath.path, withIntermediateDirectories: true, attributes: nil)
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                try imageData.write(to: fileUrl)
            }
        } catch {
            //Error writing to file
            throw AppError.storageError
        }
        let pathWithDirectory = "\(directory)/\(fullFileName)"
        return pathWithDirectory
    }
    
}
