//
//  DashboardDataSourceDelegate.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 26.01.2022.
//

import UIKit

class DashboardDataSourceDelegate: NSObject {
    private var dataSource: [Expense]?
    private var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        }
    }
    
    convenience init(dataSource: [Expense], tableView: UITableView) {
        self.init()
        self.dataSource = dataSource
        self.tableView = tableView
        self.tableView?.reloadData()
    }
    
    func update(dataSource: [Expense]) {
        self.dataSource = dataSource
        self.tableView?.reloadData()
    }
}

extension DashboardDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell.emptyCell
        guard let expense = dataSource?[indexPath.row] else { return cell }
        let expenseCell = tableView.dequeueReusableCell(for: indexPath, cellType: ExpenseTableViewCell.self)
        expenseCell.configure(expense: expense)
        cell = expenseCell
        return cell
    }
}

