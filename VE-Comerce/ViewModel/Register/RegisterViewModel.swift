//
//  RegisterViewModel.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

class RegisterViewModel {
    var error: Observable<Error?> = Observable(nil)
    var user: Observable<User?> = Observable(nil)
    
    private let registerService: RegisterService
    
    init(registerService: RegisterService) {
        self.registerService = registerService
    }
}
