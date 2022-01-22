//
//  RegisterViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import UIKit

class RegisterViewController: UIViewController {

    private let viewModel: RegisterViewModel
    
    //MARK: - Initialization
    init?(coder: NSCoder, viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
