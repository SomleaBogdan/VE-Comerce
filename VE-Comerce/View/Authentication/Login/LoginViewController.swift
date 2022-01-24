//
//  LoginViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.setTitle("Not registered yet? Register Now!", for: .normal)
            registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            registerButton.setTitleColor(.blueGem, for: .normal)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = AuthenticationViewModel(authenticationService: AuthenticationRepository())
    private var dataSourceDelegate: AuthenticationTableViewDataSourceDelegate?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelBindings()
        dataSourceDelegate = AuthenticationTableViewDataSourceDelegate(type: .login, tableView: tableView, delegate: self)
        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
        setupUI()
    }
    
    //MARK: - Private Helper Methods
    private func setupUI() {
        view.backgroundColor = .solitude
        tableView.backgroundColor = .clear
        tableView.tableHeaderView?.backgroundColor = .clear
        tableView.tableFooterView?.backgroundColor = .clear
    }
    
    //MARK: - ViewModel Bindings
    private func setupViewModelBindings() {
        viewModel.user.observe({ [weak self] user in
            guard let self = self else { return }
            guard let user = user else { return }
            self.navigateToDashboardWith(user: user)
        })
        
        viewModel.error.observe({ [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.showErrorAlertWith(description: error.localizedString)
        })
    }
    
    private func navigateToDashboardWith(user: User) {
        let dashboardViewController = UIStoryboard.dashboard.instantiateViewController(identifier: "DashboardViewController", creator: { coder in
            let invoiceRepository = InvoiceRepository(user: user)
            let receiptRepository = ReceiptRepository(user: user)
            let registerViewModel = DashboardViewModel(invoiceService: invoiceRepository,
                                                       receiptService: receiptRepository)
            return DashboardViewController(coder: coder, viewModel: registerViewModel, user: user)
        })
        navigationController?.pushViewController(dashboardViewController, animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func registerNowButtonTapped(_ sender: Any) {
        let registerViewController = UIStoryboard.authentication.instantiateViewController(identifier: "RegisterViewController", creator: { coder in
            let registerViewModel = RegisterViewModel(registerService: AuthenticationRepository())
            return RegisterViewController(coder: coder, viewModel: registerViewModel)
        })
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    
}

extension LoginViewController: AuthenticationTableViewInterface {
    func tableView(_ tableView: UITableView, didSubmitFormWith dictionary: [String : String]) {
        do {
            let user: User = try dictionary.decoded()
            viewModel.authenticate(user: user)
        } catch {
            let error = AppError(description: "The email or password are invalid.")
            showErrorAlertWith(description: error.localizedString)
        }
    }
}
