//
//  AuthenticationRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

protocol RegisterService: AnyObject {
    func register(user: Registerable, completion: @escaping (Result<User, Error>) -> Void)
}

protocol AuthenticationService: AnyObject {
    func authenticate(user: Authenticable, completion: @escaping (Result<User, Error>) -> Void)
}

class AuthenticationRepository: AuthenticationService {
    func authenticate(user: Authenticable, completion: @escaping (Result<User, Error>) -> Void) {
        
    }
}

extension AuthenticationRepository: RegisterService {
    func register(user: Registerable, completion: @escaping (Result<User, Error>) -> Void) {
        
    }
}
