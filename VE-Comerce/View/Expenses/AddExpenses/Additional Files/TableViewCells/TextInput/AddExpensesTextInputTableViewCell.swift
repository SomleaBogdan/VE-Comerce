//
//  AddExpensesTextInputTableViewCell.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

protocol AddExpensesTextInputDelegate: AnyObject {
    func addExpensesTextInputTableView(cell: AddExpensesTextInputTableViewCell, didUpdateValue newValue: Any)
}


class AddExpensesTextInputTableViewCell: UITableViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .darkGem
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.addPadding(padding: .left(15))
            textField.backgroundColor = .darkGem
            textField.textColor = .solitude
        }
    }
    
    private weak var delegate: AddExpensesTextInputDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        textField.isUserInteractionEnabled = true
        textField.delegate = nil
        titleLabel.text = nil
        textField.inputView = nil
        textField.reloadInputViews()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = false
        textField.inputView = nil
        textField.placeholder = nil
        textField.reloadInputViews()
    }
    
    
    
    func configure(field: AddExpensesFormField, delegate: AddExpensesTextInputDelegate) {
        self.delegate = delegate
        titleLabel.text = field.fieldType?.title
        textField.lightPlaceholder = field.fieldType?.placeholder
        textField.keyboardType = field.fieldType?.keyboardType ?? .default
        
        if let value = field.value as? String {
            textField.text = value
        } else if let dateValue = field.value as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            textField.text = dateFormatter.string(from: dateValue)
        }
        textField.isUserInteractionEnabled = true
        
        switch field.fieldType {
        case .issueDate, .paymentDate:
            textField.setInputViewDatePicker(target: self, selector: #selector(dateValueUpdated))
        case .total:
            textField.reloadInputViews()
            textField.delegate = self
        case .currency:
            textField.isUserInteractionEnabled = false
        default: break
        }
    }
    
    @objc
    func dateValueUpdated() {
        if let datePicker = textField.inputView as? UIDatePicker {
            delegate?.addExpensesTextInputTableView(cell: self, didUpdateValue: datePicker.date)
        }
        textField.resignFirstResponder()
    }
}

extension AddExpensesTextInputTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.addExpensesTextInputTableView(cell: self, didUpdateValue: text)
    }
}
