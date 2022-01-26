//
//  RegisterViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import UIKit

class RegisterViewController: UIViewController {

    private let viewModel: RegisterViewModel
    @IBOutlet weak var tableView: UITableView!
    private var dataSourceDelegate: AuthenticationTableViewDataSourceDelegate?
    
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
        dataSourceDelegate = AuthenticationTableViewDataSourceDelegate(type: .register, tableView: tableView, delegate: self)
        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
        setupUI()
        setupViewModelBindings()
    }
    
    //MARK: - Private Helper Methods
    private func setupUI() {
        view.backgroundColor = .solitude
        tableView.backgroundColor = .clear
        tableView.tableHeaderView?.backgroundColor = .clear
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
}

extension RegisterViewController: AuthenticationTableViewInterface {
    func tableView(_ tableView: UITableView, didSubmitFormWith dictionary: [String : String]) {
        do {
            let user: User = try dictionary.decoded()
            viewModel.register(user: user)
        } catch {
            let error = AppError(description: "All fields are required.")
            showErrorAlertWith(description: error.localizedString)
        }
    }
}
