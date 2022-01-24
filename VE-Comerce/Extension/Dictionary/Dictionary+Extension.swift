//
//  Dictionary+Extension.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import Foundation
import UIKit

extension Dictionary where Key == String {
    
    func decoded<T: Decodable>() throws -> T {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = appDelegate.persistentContainer.viewContext
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let object = try decoder.decode(T.self, from: data)
        return object
    }    
}
