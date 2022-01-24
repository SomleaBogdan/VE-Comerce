//
//  AppError.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

enum AppError: Error {
    case custom(description: String)
    init(description: String) {
        self = .custom(description: description)
    }
    
    var localizedString: String? {
        switch self {
        case .custom(let description):
            return description
        }
    }
}
