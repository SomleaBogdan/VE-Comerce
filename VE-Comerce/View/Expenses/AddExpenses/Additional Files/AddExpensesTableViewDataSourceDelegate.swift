//
//  AddExpensesTableViewDataSourceDelegate.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import Foundation
import UIKit

enum AddExpenseType {
    case receipt, invoice
    
    var fields: [AddExpensesFormField] {
        switch self {
        case .invoice:
            return AddExpensesFormField.asInvoiceFields
        case .receipt:
            return AddExpensesFormField.asReceiptFields
        }
    }
}

protocol AddExpensesDelegate: AnyObject {
    func expenses(delegateDataSource: AddExpensesTableViewDataSourceDelegate, didSelectRowFor field: AddExpensesFormField)
}


class AddExpensesTableViewDataSourceDelegate: NSObject {
    
    var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
            tableView?.register(cellType: AddExpensesTextInputTableViewCell.self)
            tableView?.register(cellType: AddExpensesSwitchTableViewCell.self)
            tableView?.register(cellType: AddExpenseImageTableViewCell.self)
            tableView?.rowHeight = UITableView.automaticDimension
            tableView?.estimatedRowHeight = 60
        }
    }
    
    private var type: AddExpenseType? {
        didSet {
            dataSource = type?.fields
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView?.reloadData()
            }
        }
    }
    
    private weak var delegate: AddExpensesDelegate?
    private var dataSource: [AddExpensesFormField]?
    
    convenience init(type: AddExpenseType, tableView: UITableView, delegate: AddExpensesDelegate) {
        self.init()
        self.delegate = delegate
        defer {
            self.tableView = tableView
            self.type = type
        }
    }
    
    //MARK: - Internal Methods
    func set(type: AddExpenseType) {
        self.type = type
    }
    
    func updateDataSourceFor(field: AddExpensesFormFieldType, with value: Any) {
        guard let index = dataSource?.firstIndex(where: {$0.fieldType == field }) else { return }
        dataSource?.updateAt(index: index, value: value)
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func processedDataSourceDictionary() -> [String: Any]? {
        return dataSource?.asDictionary
    }
    
    //MARK: - Cell Factory
    private func createCellFor(field: AddExpensesFormField, at indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell?
        guard let fieldType = field.fieldType else { return nil }
        switch fieldType {
        case .image:
            cell = createImageCellFor(field: field, at: indexPath)
        case .currency, .issueDate, .paymentDate, .total:
            cell = createTextInputCellFor(field: field, at: indexPath)
        case .isPaid:
            cell = createSwitchCellFor(field: field, at: indexPath)
        }
        return cell
    }

    
    private func createTextInputCellFor(field: AddExpensesFormField, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView?.dequeueReusableCell(for: indexPath, cellType: AddExpensesTextInputTableViewCell.self)
        cell?.configure(field: field, delegate: self)
        return cell
    }
    
    private func createSwitchCellFor(field: AddExpensesFormField, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView?.dequeueReusableCell(for: indexPath, cellType: AddExpensesSwitchTableViewCell.self)
        cell?.configure(field: field, delegate: self)
        return cell
    }
    
    private func createImageCellFor(field: AddExpensesFormField, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView?.dequeueReusableCell(for: indexPath, cellType: AddExpenseImageTableViewCell.self)
        cell?.configure(field: field)
        return cell
    }
}

//MARK: - UITableViewDataSource
extension AddExpensesTableViewDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell.emptyCell
        if let field = dataSource?[indexPath.row] {
            if let fieldCell = createCellFor(field: field, at: indexPath) {
                cell = fieldCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
}

//MARK: - UITableViewDelegate
extension AddExpensesTableViewDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let field = dataSource?[indexPath.row] else { return }
        delegate?.expenses(delegateDataSource: self, didSelectRowFor: field)
    }
}

//MARK: - AddExpensesTextInputDelegate
extension AddExpensesTableViewDataSourceDelegate: AddExpensesTextInputDelegate {
    func addExpensesTextInputTableView(cell: AddExpensesTextInputTableViewCell, didUpdateValue newValue: Any) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        dataSource?.updateAt(index: indexPath.row, value: newValue)
        tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - AddExpensesSwitchCellDelegate
extension AddExpensesTableViewDataSourceDelegate: AddExpensesSwitchCellDelegate {
    func addExpensesSwitch(cell: AddExpensesSwitchTableViewCell, didChangeSwitchValue newValue: Bool) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        dataSource?.updateAt(index: indexPath.row, value: newValue)
        if newValue == true {
            let paymentDate = AddExpensesFormField(type: .paymentDate)
            dataSource?.insert(paymentDate, at: indexPath.row + 1)
            tableView?.beginUpdates()
            tableView?.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: .left)
            tableView?.endUpdates()
        } else {
            guard let indexToRemove = dataSource?.firstIndex(where: {$0.fieldType == .paymentDate}) else { return }
            dataSource?.remove(at: indexToRemove)
            tableView?.beginUpdates()
            tableView?.deleteRows(at: [IndexPath(row: indexToRemove, section: 0)], with: .right)
            tableView?.endUpdates()
        }
    }
}
