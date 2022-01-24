//
//  DashboardViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

class DashboardViewController: UIViewController {
    
    private var viewModel: DashboardViewModel
    private var user: User
    
    //MARK: - Initialization
    init?(coder: NSCoder, viewModel: DashboardViewModel, user: User) {
        self.user = user
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - ViewModel Bindings
    private func setupViewModelBindings() {
        viewModel.receipts.observe{ [weak self] receipts in
            guard let self = self else { return }
            guard let receipts = receipts else { return }
            print("WE HAVE RECEIPTS")
        }
        
        viewModel.invoices.observe { [weak self] invoices in
            guard let self = self else { return }
            guard let invoices = invoices else { return }
            print("WE HAVE INVOICES")
        }
        
        viewModel.error.observe{ [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.showErrorAlertWith(description: error.localizedString)
        }
    }
    
    @IBAction func addExpensesButtonTapped(_ sender: Any) {
        navigateToAddExpensesWith(user: user)
    }
    
    private func navigateToAddExpensesWith(user: User) {
        let addExpensesViewController = UIStoryboard.expenses.instantiateViewController(identifier: "AddExpensesViewController", creator: { coder in
            let invoiceRepository = InvoiceRepository(user: user)
            let receiptRepository = ReceiptRepository(user: user)
            let addExpensesViewModel = AddExpensesViewModel(invoiceService: invoiceRepository,
                                                            receiptService: receiptRepository)
            return AddExpensesViewController(coder: coder, viewModel: addExpensesViewModel)
        })
        navigationController?.pushViewController(addExpensesViewController, animated: true)
    }
}
