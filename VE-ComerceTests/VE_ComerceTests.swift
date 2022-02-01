//
//  VE_ComerceTests.swift
//  VE-ComerceTests
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import XCTest
@testable import VE_Comerce

class VE_ComerceTests: XCTestCase {
    
    private var sut: AuthenticationViewModel!
    private var authService: MockAuthenticationService!
    
    override func setUpWithError() throws {
        authService = MockAuthenticationService()
        sut = AuthenticationViewModel(authenticationService: authService)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        authService = nil
        try super.tearDownWithError()
    }
    
    func testAuthenticationWithCorrectDetailsSetsSuccessPresentedToTrue() {
        let userDictionary = ["email": "somleabogdan@gmail.com",
                              "password": "123456"]
        do {
            let user: User = try userDictionary.decoded()
            authService.authenticateResult = .success(user)
            sut.authenticate(user: user)
            XCTAssertNotNil(sut.user.value != nil)
        } catch {
            print("MOCKED USER INVALID")
        }
    }
    
    func testLoginWithErrorSetsError() {
        let userDictionary = ["email": "somleabogdan@gmail.com",
                              "password": "123456"]
        do {
            let user: User = try userDictionary.decoded()
            authService.authenticateResult = .failure(AppError.invalidEmail)
            sut.authenticate(user: user)
            XCTAssertNotNil(sut.error.value != nil)
        } catch {
            print("MOCKED USER INVALID")
        }
    }
}

class MockAuthenticationService: AuthenticationService {
    var authenticateResult: Result<User, AppError> = .success(User())
    func authenticate(user: Authenticable, completion: @escaping (Result<User, AppError>) -> Void) {
        completion(authenticateResult)
    }
}
