//
//  AuthenticationViewModel.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

class AuthenticationViewModel {
    var error: Observable<AppError?> = Observable(nil)
    var user: Observable<User?> = Observable(nil)
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func authenticate(user: Authenticable) {
        let validated = user.validated()
        switch validated {
        case .invalid(let errorString):
            self.error.value = AppError(description: errorString)
        case .success:
            performAuthentication(user: user)
        default:
            break
        }
    }
    
    private func performAuthentication(user: Authenticable) {
        authenticationService.authenticate(user: user) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user.value = user
            case .failure(let error):
                self.error.value = AppError(description: error.localizedDescription)
            }
        }
    }
}
