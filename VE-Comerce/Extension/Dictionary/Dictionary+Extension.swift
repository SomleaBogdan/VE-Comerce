//
//  Dictionary+Extension.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import Foundation

extension Dictionary where Key == String {
    
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        let object = try decoder.decode(T.self, from: data)
        return object
    }
}
