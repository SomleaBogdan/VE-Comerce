//
//  AddExpensesViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

class AddExpensesViewController: UIViewController {
    
    private var viewModel: AddExpensesViewModel
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var receiptInvoiceSegmentedControl: UISegmentedControl! {
        didSet {
            receiptInvoiceSegmentedControl.setTitle("Invoice", forSegmentAt: 0)
            receiptInvoiceSegmentedControl.setTitle("Receipt", forSegmentAt: 1)
        }
    }
    
    //MARK: - Initialization
    init?(coder: NSCoder, viewModel: AddExpensesViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.title = "Add Expense"
    }
    
    //MARK: - IBActions
    @IBAction func receiptInvoiceSegmentedValueChanged(_ sender: Any) {
        
    }
    
}
