//
//  AddExpensesViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

protocol AddExpensesControllerDelegate: AnyObject {
    func addExpenses(controller: AddExpensesViewController, didSaveNew invoice: Invoice)
    func addExpenses(controller: AddExpensesViewController, didSaveNew receipt: Receipt)
}

class AddExpensesViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var receiptInvoiceSegmentedControl: UISegmentedControl! {
        didSet {
            receiptInvoiceSegmentedControl.setTitle("Invoice", forSegmentAt: 0)
            receiptInvoiceSegmentedControl.setTitle("Receipt", forSegmentAt: 1)
        }
    }
    
    private var viewModel: AddExpensesViewModel
    private var dataSourceDelegate: AddExpensesTableViewDataSourceDelegate?
    private weak var delegate: AddExpensesControllerDelegate?
    
    //MARK: - Initialization
    init?(coder: NSCoder, viewModel: AddExpensesViewModel, delegate: AddExpensesControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dataSourceDelegate = AddExpensesTableViewDataSourceDelegate(type: .invoice, tableView: tableView, delegate: self)
        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
        setupUI()
        setupViewModelBindings()
    }
    
    //MARK: - Private Helper Methods
    private func setupUI() {
        self.title = "Add Expense"
        view.backgroundColor = .solitude
        tableView.backgroundColor = .clear
        tableView.tableHeaderView?.backgroundColor = .clear
        tableView.tableFooterView?.backgroundColor = .clear
        let rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    //MARK: - ViewModel Bindigns
    private func setupViewModelBindings() {
        viewModel.receipt.observe({ [weak self] receipt in
            guard let self = self else { return }
            guard let receipt = receipt else { return }
            self.delegate?.addExpenses(controller: self, didSaveNew: receipt)
            self.navigationController?.popViewController(animated: true)
        })
        
        viewModel.invoice.observe({ [weak self] invoice in
            guard let self = self else { return }
            guard let invoice = invoice else { return }
            self.delegate?.addExpenses(controller: self, didSaveNew: invoice)
            self.navigationController?.popViewController(animated: true)
        })
        
        viewModel.error.observe({ [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.showErrorAlertWith(description: error.localizedString)
        })
    }
    
    private func showImageActionSheet() {
        let imageActionSheet = UIAlertController(title: "Select media type", message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            self?.showImagePicker(type: .camera)
        }
        
        let chooseFromLibrary = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.showImagePicker(type: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        imageActionSheet.addAction(takePhotoAction)
        imageActionSheet.addAction(chooseFromLibrary)
        imageActionSheet.addAction(cancelAction)
        present(imageActionSheet, animated: true, completion: nil)
        
    }
    
    var imagePicker: CustomImagePicker?
    private func showImagePicker(type: UIImagePickerController.SourceType) {
        imagePicker = CustomImagePicker(sourceType: type, delegate: self)
        imagePicker?.presentOn(controller: self)
    }
    
    private func goToCurrency() {
        guard let currencyViewController = UIStoryboard.expenses.instantiateViewController(withIdentifier: "CurrencyViewController") as? CurrencyViewController else { return }
        currencyViewController.delegate = self
        navigationController?.pushViewController(currencyViewController, animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func receiptInvoiceSegmentedValueChanged(_ sender: Any) {
        guard let segmentedControl = sender as? UISegmentedControl else { return }
        let index = segmentedControl.selectedSegmentIndex
        dataSourceDelegate?.set(type: index == 0 ? .invoice: .receipt)
    }
    
    @objc
    func saveButtonTapped() {
        view.endEditing(true)
        guard let dictionary = dataSourceDelegate?.processedDataSourceDictionary() else {
            return
        }
        let isInvoice = receiptInvoiceSegmentedControl.selectedSegmentIndex == 0
        do {
            if isInvoice {
                try viewModel.storeInvoiceFrom(dictionary: dictionary)
            } else {
                try viewModel.storeReceiptFrom(dictionary: dictionary)
            }
        } catch let exception {
            if let err = exception as? AppError {
                self.showErrorAlertWith(description: err.localizedString)
            }
        }
    }
}

//MARK: - AddExpensesDelegate
extension AddExpensesViewController: AddExpensesDelegate {
    func expenses(delegateDataSource: AddExpensesTableViewDataSourceDelegate, didSelectRowFor field: AddExpensesFormField) {
        switch field.fieldType {
        case .image:
            showImageActionSheet()
        case .currency:
            goToCurrency()
        default: break
        }
    }
}

//MARK: - CustomImagePickerDelegate
extension AddExpensesViewController: CustomImagePickerDelegate {
    func imagePicker(_ picker: CustomImagePicker, didSelect image: UIImage?) {
        guard let image = image else {
            return
        }
        dataSourceDelegate?.updateDataSourceFor(field: .image, with: image)
    }
}

//MARK: - CurrencyDelegate
extension AddExpensesViewController: CurrencyDelegate {
    func currencyView(controller: CurrencyViewController, didSelect currency: String) {
        dataSourceDelegate?.updateDataSourceFor(field: .currency, with: currency)
    }
}


