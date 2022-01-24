//
//  AuthenticationRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

protocol RegisterService: AnyObject {
    func register(user: Registerable, completion: @escaping (Result<User, AppError>) -> Void)
}

protocol AuthenticationService: AnyObject {
    func authenticate(user: Authenticable, completion: @escaping (Result<User, AppError>) -> Void)
}

class AuthenticationRepository: AuthenticationService {
    func authenticate(user: Authenticable, completion: @escaping (Result<User, AppError>) -> Void) {
        let userStore = UserStore(authenticable: user)
        do {
            let user = try userStore.attemptAuthentication()
            completion(.success(user))
        } catch let error {
            if let err = error as? AppError {
                completion(.failure(err))
            }
        }
    }
}

extension AuthenticationRepository: RegisterService {
    func register(user: Registerable, completion: @escaping (Result<User, AppError>) -> Void) {
        let userStore = UserStore(registerable: user)
        do {
            let user = try userStore.storeUser()
            completion(.success(user))
        } catch let error {
            if let err = error as? AppError {
                completion(.failure(err))
            }
        }
        
    }
}
