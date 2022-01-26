//
//  CurrencyViewController.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 25.01.2022.
//

import UIKit

protocol CurrencyDelegate: AnyObject {
    func currencyView(controller: CurrencyViewController, didSelect currency: String)
}

class CurrencyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var dataSource = Locale.isoCurrencyCodes
    weak var delegate: CurrencyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CurrencyTableViewCell.self)
        cell.configure(currency: dataSource[indexPath.row])
        return cell
    }
}

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.currencyView(controller: self, didSelect: dataSource[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
