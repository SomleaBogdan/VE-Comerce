//
//  AppError.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

enum AppError: Error {
    case invalidEmail
    case invalidPassword
    case unableToAuthenticate
    case unableToRegister
    case userRegisteredAlready
    case storageError
    case custom(description: String)
    init(description: String) {
        self = .custom(description: description)
    }
    
    var localizedString: String? {
        switch self {
        case .custom(let description):
            return description
        case .invalidEmail:
            return "Your email is not registered. Register now."
        case .invalidPassword:
            return "Wrong password. Try again later."
        case .unableToAuthenticate:
            return "Unable to validate credentials."
        case .storageError:
            return "Storage Error."
        case .unableToRegister:
            return "Unable to register."
        case .userRegisteredAlready:
            return "User with email is already registered."
        }
    }
}
