//
//  AuthenticationRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

protocol AuthenticationService: AnyObject {
    func authenticateUser(with email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}

class AuthenticationRepository: AuthenticationService {
    func authenticateUser(with email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let user = User(email: "somleabogdan@gmail.com", password: "123456  ")
        completion(.success(user))
    }
}
