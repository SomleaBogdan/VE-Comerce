//
//  AuthenticationViewModel.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

class AuthenticationViewModel {
    var error: Observable<Error?> = Observable(nil)
    var user: Observable<User?> = Observable(nil)
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func authenticateUser(with email: String, password: String) {
        authenticationService.authenticateUser(with: email, password: password, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user.value = user
            case .failure(let error):
                self.error.value = error
            }
        })
    }
}
