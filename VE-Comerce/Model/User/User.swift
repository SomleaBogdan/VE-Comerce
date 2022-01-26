//
//  User.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

enum ValidationStatus {
    case success
    case invalid(error: String)
}


protocol Authenticable: AnyObject {
    var authenticableEmail: String { get }
    var authenticablePassword: String { get }
    
    func validated() -> ValidationStatus?
}

protocol Registerable: AnyObject {
    var registerableFirstName: String { get }
    var registerableLastName: String { get }
    var registerableEmail: String { get }
    var registerablePassword: String { get }
    var registerableConfirmPassword: String { get }
    
    func registrationValidated() -> ValidationStatus?
}

public class User: NSManagedObject, Codable {
    @NSManaged var identifier: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var email: String
    
    var password: String?
    var confirmPassword: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "identifier"
        case email = "email"
        case password = "password"
        case firstName = "first_name"
        case lastName = "last_name"
        case confirmPassword = "confirm_password"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.identifier = try container.decodeIfPresent(String.self, forKey: .identifier) ?? ""
            self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
            self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
            self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
            self.password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
            self.confirmPassword = try container.decodeIfPresent(String.self, forKey: .confirmPassword) ?? ""
        } catch {
            fatalError()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
}

extension User: Authenticable {
    var authenticableEmail: String {
        get {
            return self.email
        }
    }
    var authenticablePassword: String {
        get {
            return self.password ?? ""
        }
    }
    
    func validated() -> ValidationStatus? {
        if !authenticableEmail.isValidEmail() {
            return .invalid(error: "Your email is invalid.")
        }
        if authenticablePassword.count < 6 {
            return .invalid(error: "Password is too short. Password should be at least 6 characters long.")
        }
        return .success
    }
}

extension User: Registerable {
    var registerableFirstName: String {
        get {
            return self.firstName ?? ""
        }
    }
    
    var registerableLastName: String {
        get {
            return self.lastName ?? ""
        }
    }
    
    var registerableEmail: String {
        get {
            return self.email
        }
    }
    
    var registerablePassword: String {
        get {
            return self.password ?? ""
        }
    }
    
    var registerableConfirmPassword: String {
        return self.confirmPassword ?? ""
    }
    
    func registrationValidated() -> ValidationStatus? {
        if registerableFirstName.count < 3 {
            return .invalid(error:"The first name is too short.")
        }
        
        if registerableLastName.count < 3 {
            return .invalid(error:"The last name is too short.")
        }
        
        if !registerableEmail.isValidEmail() {
            return .invalid(error:"The email is too short.")
        }
        if registerablePassword.count < 6 {
            return .invalid(error:"Password is too short. Password should be at least 6 characters long.")
        }
        
        if registerablePassword != registerableConfirmPassword {
            return .invalid(error:"Your passwords do not match.")
        }
        return .success
        
    }
}
