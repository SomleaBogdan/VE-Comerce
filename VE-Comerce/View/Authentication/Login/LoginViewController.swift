//
//  LoginViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel = AuthenticationViewModel(authenticationService: AuthenticationRepository())
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelBindings()
    }
    
    //MARK: - Private Helper Methods
    private func setupViewModelBindings() {
        viewModel.user.observe({ user in
            print("WE HAVE USER")
        })
        
        viewModel.error.observe({ error in
            print("WE HAVE ERROR")
        })
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let registerViewController = UIStoryboard.authentication.instantiateViewController(identifier: "RegisterViewController", creator: { coder in
            let registerViewModel = RegisterViewModel(registerService: RegisterRepository())
            return RegisterViewController(coder: coder, viewModel: registerViewModel)
        })
        navigationController?.pushViewController(registerViewController, animated: true)
//        viewModel.authenticateUser(with: "somleabogdan@gmail.com", password: "123456")
    }
}
