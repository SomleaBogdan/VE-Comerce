//
//  AuthenticationTableViewDataSourceDelegate.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

enum AuthenticationTableViewType {
    case register, login
    
    var fields: [AuthenticationFormField] {
        switch self {
        case .register:
            return AuthenticationFormField.asRegisterFields
        case .login:
            return AuthenticationFormField.asLoginFields
        }
    }
}

protocol AuthenticationTableViewInterface: AnyObject {
    func tableView(_ tableView: UITableView, didSubmitFormWith dictionary: [String: String])
}

class AuthenticationTableViewDataSourceDelegate: NSObject {
    
    private var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
            tableView?.register(cellType: AuthenticationTextInputTableViewCell.self)
            tableView?.register(cellType: AuthenticationButtonTableViewCell.self)
            tableView?.rowHeight = UITableView.automaticDimension
            tableView?.estimatedRowHeight = 60
        }
    }
    
    private var type: AuthenticationTableViewType? {
        didSet {
            dataSource = type?.fields
            tableView?.reloadData()
        }
    }
    
    private var dataSource: [AuthenticationFormField]?
    
    private weak var delegate: AuthenticationTableViewInterface?
    
    
    convenience init(type: AuthenticationTableViewType, tableView: UITableView, delegate: AuthenticationTableViewInterface) {
        self.init()
        self.delegate = delegate
        defer {
            self.tableView = tableView
            self.type = type
        }
    }
    
    //MARK: - Cell Factory
    private func createCellFor(field: AuthenticationFormField, at indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell?
        switch field.fieldType {
        case .email, .password, .firstName, .lastName, .confirmPassword:
            cell = createTextInputCellFor(field: field, at: indexPath)
        case .submit:
            cell = createButtonCellFor(field: field, at: indexPath)
        default:
            break
        }
        return cell
    }
    
    private func createTextInputCellFor(field: AuthenticationFormField, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView?.dequeueReusableCell(for: indexPath, cellType: AuthenticationTextInputTableViewCell.self)
        cell?.configure(field: field, delegate: self)
        return cell
    }
    
    private func createButtonCellFor(field: AuthenticationFormField, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView?.dequeueReusableCell(for: indexPath, cellType: AuthenticationButtonTableViewCell.self)
        cell?.configure(field: field)
        return cell
    }
    
    private func textInputCellFor(indexPath: IndexPath) -> AuthenticationTextInputTableViewCell? {
        guard let cell = tableView?.cellForRow(at: indexPath) as? AuthenticationTextInputTableViewCell else { return nil }
        return cell
    }
}

//MARK: - UITableViewDataSource
extension AuthenticationTableViewDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell.emptyCell
        if let field = dataSource?[indexPath.row] {
            if let fieldCell = createCellFor(field: field, at: indexPath) {
                cell = fieldCell
            }
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension AuthenticationTableViewDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let field = dataSource?[indexPath.row], let fieldType = field.fieldType else {
            return
        }
        
        switch fieldType {
        case .email, .password, .firstName, .lastName, .confirmPassword:
            break
        case .submit:
            tableView.endEditing(true)
            guard let authenticableDictionary = dataSource?.asAuthenticableDictionary else {
                return
            }
            delegate?.tableView(tableView, didSubmitFormWith: authenticableDictionary)
            
        }
    }
}

extension AuthenticationTableViewDataSourceDelegate: AuthenticationTextInputDelegate {
    func textInput(cell: AuthenticationTextInputTableViewCell, didUpdateFieldValue newValue: String) {
        guard let cellIndex = tableView?.indexPath(for: cell) else { return }
        dataSource?.updateAt(index: cellIndex.row, value: newValue)
    }
}
