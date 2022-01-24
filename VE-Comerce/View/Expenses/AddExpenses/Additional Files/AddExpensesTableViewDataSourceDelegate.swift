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


class AddExpensesTableViewDataSourceDelegate: NSObject {
    
    private var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
            tableView?.register(cellType: AddExpensesLabelTableViewCell.self)
            tableView?.register(cellType: AddExpensesTextInputTableViewCell.self)
            tableView?.register(cellType: AddExpensesSwitchTableViewCell.self)
            tableView?.rowHeight = UITableView.automaticDimension
            tableView?.estimatedRowHeight = 60
        }
    }
    
    private var type: AddExpenseType? {
        didSet {
            dataSource = type?.fields
            tableView?.reloadData()
        }
    }
    
    private var dataSource: [AddExpensesFormField]?

    convenience init(type: AddExpenseType, tableView: UITableView) {
        self.init()
        defer {
            self.tableView = tableView
            self.type = type
        }
    }
    
    //MARK: - Cell Factory
    private func createCellFor(field: AddExpensesFormField, at indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell?
        guard let fieldType = field.fieldType else { return nil }
        switch fieldType {
        case .image:
            cell = createTextInputCellFor(field: field, at: indexPath)
        case .currency, .issueDate, .paymentDate:
            cell = createLabelCellFor(field: field, at: indexPath)
        case .isPaid:
            cell = createSwitchCellFor(field: field, at: indexPath)
        case .total:
            cell = createTextInputCellFor(field: field, at: indexPath)
        }
        return cell
    }
    
    private func createLabelCellFor(field: AddExpensesFormField, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView?.dequeueReusableCell(for: indexPath, cellType: AddExpensesLabelTableViewCell.self)
        cell?.configure(field: field)
        return cell
    }
    
    private func createTextInputCellFor(field: AddExpensesFormField, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView?.dequeueReusableCell(for: indexPath, cellType: AddExpensesTextInputTableViewCell.self)
        cell?.configure(field: field)
        return cell
    }
    
    private func createSwitchCellFor(field: AddExpensesFormField, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView?.dequeueReusableCell(for: indexPath, cellType: AddExpensesSwitchTableViewCell.self)
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
