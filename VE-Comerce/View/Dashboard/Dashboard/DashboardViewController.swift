//
//  DashboardViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dataSourceSegmentedControl: UISegmentedControl! {
        didSet {
            dataSourceSegmentedControl.setTitle("Invoices", forSegmentAt: 0)
            dataSourceSegmentedControl.setTitle("Receipts", forSegmentAt: 1)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: DashboardViewModel
    private var user: User
    
    private var contentType: AddExpenseType {
        didSet {
            switch contentType {
            case .receipt:
                viewModel.fetchUserReceipts()
            case .invoice:
                viewModel.fetchUserInvoices()
            }
        }
    }
    
    //MARK: - Initialization
    init?(coder: NSCoder, viewModel: DashboardViewModel, user: User) {
        self.user = user
        self.viewModel = viewModel
        self.contentType = .invoice
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataSourceDelegate: DashboardDataSourceDelegate?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSourceDelegate
        setupUI()
        setupViewModelBindings()
        self.contentType = .invoice
    }
    
    private func setupUI() {
        let rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(addExpensesButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    //MARK: - ViewModel Bindings
    private func setupViewModelBindings() {
        viewModel.receipts.observe{ [weak self] receipts in
            guard let self = self else { return }
            guard let receipts = receipts else { return }
            print("WE HAVE RECEIPTS => \(receipts)")
            self.dataSourceDelegate = DashboardDataSourceDelegate(dataSource: receipts, tableView: self.tableView)
            self.tableView.dataSource = self.dataSourceDelegate
        }
        
        viewModel.invoices.observe { [weak self] invoices in
            guard let self = self else { return }
            guard let invoices = invoices else { return }
            self.dataSourceDelegate = DashboardDataSourceDelegate(dataSource: invoices, tableView: self.tableView)
            self.tableView.dataSource = self.dataSourceDelegate
        }
        
        viewModel.error.observe{ [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.showErrorAlertWith(description: error.localizedString)
        }
    }
    
    @objc
    func addExpensesButtonTapped(_ sender: Any) {
        navigateToAddExpensesWith(user: user)
    }
    
    private func navigateToAddExpensesWith(user: User) {
        let addExpensesViewController = UIStoryboard.expenses.instantiateViewController(identifier: "AddExpensesViewController", creator: { coder in
            let invoiceRepository = InvoiceRepository(user: user)
            let receiptRepository = ReceiptRepository(user: user)
            let addExpensesViewModel = AddExpensesViewModel(invoiceService: invoiceRepository,
                                                            receiptService: receiptRepository)
            return AddExpensesViewController(coder: coder, viewModel: addExpensesViewModel, delegate: self)
        })
        navigationController?.pushViewController(addExpensesViewController, animated: true)
    }
    
    @IBAction func dataSourceSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.contentType = sender.selectedSegmentIndex == 0 ? .invoice: .receipt
    }
}

//MARK: - AddExpensesControllerDelegate
extension DashboardViewController: AddExpensesControllerDelegate {
    func addExpenses(controller: AddExpensesViewController, didSaveNew invoice: Invoice) {
        //REFRESH DATA
        self.viewModel.fetchUserInvoices()
        self.dataSourceSegmentedControl.selectedSegmentIndex = 0
    }
    
    func addExpenses(controller: AddExpensesViewController, didSaveNew receipt: Receipt) {
        //REFRESH DATA
        self.viewModel.fetchUserReceipts()
        self.dataSourceSegmentedControl.selectedSegmentIndex = 1
    }
}
