//
//  RegisterViewModel.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

class RegisterViewModel {
    var error: Observable<AppError?> = Observable(nil)
    var user: Observable<User?> = Observable(nil)
    
    private let registerService: RegisterService
    
    init(registerService: RegisterService) {
        self.registerService = registerService
    }
    
    //MARK: - Register
    func register(user: Registerable) {
        let validated = user.registrationValidated()
        switch validated {
        case .invalid(let errorString):
            self.error.value = AppError(description: errorString)
        case .success:
            performRegister(user: user)
        default:
            break
        }
    }
    
    func performRegister(user: Registerable) {
        registerService.register(user: user) { [weak self] result in
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
