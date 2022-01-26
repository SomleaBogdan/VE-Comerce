//
//  Receipt.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 26.01.2022.
//

import UIKit
import CoreData

class Receipt: NSManagedObject, Codable {
    @NSManaged var imagePath: String?
    @NSManaged var currency: String
    @NSManaged var paymentDate: Date?
    @NSManaged var total: Double
    @NSManaged var user: User
    
    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case total = "total"
        case imagePath = "image_path"
        case paymentDate = "payment_date"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "Receipt", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
            self.total = try container.decodeIfPresent(Double.self, forKey: .total) ?? -1.0
            
            let paymentDateValue = try container.decodeIfPresent(Date.self, forKey: .paymentDate)
            self.paymentDate = paymentDateValue
            
            self.imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)
        } catch let exception {
            print("EXCEPTION => \(exception)")
            fatalError()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
    func validated() -> ValidationStatus? {
        if !Locale.isoCurrencyCodes.contains(where: {$0 == currency}) {
            return .invalid(error: "Invalid currency.")
        }

        if total < 0 {
            return .invalid(error: "Entered amount is invalid.")
        }
        
        return .success
    }
}

extension Receipt: Expense {
    var isPaid: Bool {
        return true
    }
    
    var image: String? {
        return self.imagePath
    }
    
    var totalWithCurrency: String {
        return "\(self.total) \(self.currency)"
    }
    
    var paymentDateString: String? {
        guard let paymentDate = paymentDate else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: paymentDate)
    }
    
    var issueDateString: String? {
        return nil
    }
}
