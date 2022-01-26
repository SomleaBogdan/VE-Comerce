//
//  UserStore.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit
import KeychainSwift
import CoreData

class UserStore: NSObject {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var authenticable: Authenticable?
    private var registerable: Registerable?
    
    override init() {
        super.init()
        authenticable = nil
        registerable = nil
    }
    
    convenience init(authenticable: Authenticable) {
        self.init()
        self.authenticable = authenticable
    }
    
    convenience init(registerable: Registerable) {
        self.init()
        self.registerable = registerable
    }
    
    func attemptAuthentication() throws -> User {
        guard let authenticable = authenticable else {
            throw AppError.unableToAuthenticate
        }
        
        let keychain = KeychainSwift()
        guard let password = keychain.get(authenticable.authenticableEmail) else {
            throw AppError.invalidEmail
        }
        
        guard password == authenticable.authenticablePassword else {
            throw AppError.invalidPassword
        }
        
        return try fetchUser()
    }
    
    func fetchUser() throws -> User {
        guard let authenticable = authenticable else {
            throw AppError.storageError
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", authenticable.authenticableEmail)
        guard let users = try? context.fetch(fetchRequest), let user = users.first else {
            throw AppError.storageError
        }
        
        return user
    }
    
    //Registration methods
    func attemptRegister() throws -> User {
        guard let registerable = registerable else {
            throw AppError.unableToRegister
        }
        
        let keychain = KeychainSwift()
        if keychain.get(registerable.registerableEmail) != nil {
            throw AppError.userRegisteredAlready
        }
        let storedUser = try storeUser()
        return storedUser
    }
    
    func storeUser() throws -> User {
        guard let registerable = NSEntityDescription.insertNewObject(forEntityName: "User", into: appDelegate.persistentContainer.viewContext) as? User else {
            throw AppError.storageError
        }
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch {
            throw AppError.storageError
        }
        try storeCredentials()
        return registerable
    }
    
    func storeCredentials() throws {
        guard let registerable = registerable else {
            throw AppError.unableToRegister
        }
        let keychain = KeychainSwift()
        keychain.set(registerable.registerablePassword, forKey: registerable.registerableEmail)
    }
    
}
