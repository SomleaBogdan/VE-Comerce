//
//  RegisterRepository.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

protocol RegisterService: AnyObject {
    func registerUser(with email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}

class RegisterRepository: RegisterService {
    func registerUser(with email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let user = User(email: "somleabogdan@gmail.com", password: "123456  ")
        completion(.success(user))
    }
}
