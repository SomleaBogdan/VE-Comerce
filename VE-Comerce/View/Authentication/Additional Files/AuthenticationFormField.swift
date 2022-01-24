//
//  AuthenticationFormField.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

enum AuthenticationFormFieldType {
    case firstName, lastName, email, password, confirmPassword, submit(title: String)
    
    var title: String {
        switch self {
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        case .email:
            return "Email"
        case .password:
            return "Password"
        case .confirmPassword:
            return "Confirm Password"
        case .submit(let title):
            return title
        }
    }
    
    var placeholder: String? {
        switch self {
        case .firstName:
            return "John"
        case .lastName:
            return "Doe"
        case .email:
            return "user@ecommerce.com"
        case .password:
            return "password"
        case .confirmPassword:
            return "confirm password"
        case .submit:
            return nil
        }
    }
    
    var hasSecureTextEntry: Bool {
        switch self {
        case .password, .confirmPassword:
            return true
        default:
            return false
        }
    }
    
    var key: String? {
        switch self {
        case .firstName:
            return "first_name"
        case .lastName:
            return "last_name"
        case .email:
            return "email"
        case .password:
            return "password"
        case .confirmPassword:
            return "confirm_password"
        case .submit:
            return nil
        }
    }
}

class AuthenticationFormField: NSObject {
    
    static let asLoginFields = [AuthenticationFormField(type: .email),
                                AuthenticationFormField(type: .password),
                                AuthenticationFormField(type: .submit(title: "Login"))]
    
    static let asRegisterFields = [AuthenticationFormField(type: .firstName),
                                   AuthenticationFormField(type: .lastName),
                                   AuthenticationFormField(type: .email),
                                   AuthenticationFormField(type: .password),
                                   AuthenticationFormField(type: .confirmPassword),
                                   AuthenticationFormField(type: .submit(title: "Register"))]
    
    var fieldType: AuthenticationFormFieldType?
    var value: String?
    
    override init() {
        super.init()
        self.fieldType = nil
        self.value = nil
    }
    
    convenience init(type: AuthenticationFormFieldType) {
        self.init()
        self.fieldType = type
    }
}

extension Array where Element == AuthenticationFormField {
    var asAuthenticableDictionary: [String: String] {
        var dictionary: [String: String] = [:]
        for field in self {
            switch field.fieldType {
            case .firstName, .lastName, .email, .password, .confirmPassword:
                if let key = field.fieldType?.key {
                    dictionary[key] = field.value
                }
            default:
                break
            }
        }
        return dictionary
    }
    
    mutating func updateAt(index: Int, value: String) {
        self[index].value = value
    }
}
