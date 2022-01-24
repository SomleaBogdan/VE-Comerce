//
//  AuthenticationTextInputTableViewCell.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

protocol AuthenticationTextInputDelegate: AnyObject {
    func textInput(cell: AuthenticationTextInputTableViewCell, didUpdateFieldValue newValue: String)
}

class AuthenticationTextInputTableViewCell: UITableViewCell, NibLoadable, Reusable {

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
    
    private weak var delegate: AuthenticationTextInputDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = .none
        textField.delegate = self
    }
    
    func configure(field: AuthenticationFormField, delegate: AuthenticationTextInputDelegate) {
        self.delegate = delegate
        textField.lightPlaceholder = field.fieldType?.placeholder
        textField.isSecureTextEntry = field.fieldType?.hasSecureTextEntry ?? false
        titleLabel.text = field.fieldType?.title
    }
}

extension AuthenticationTextInputTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.textInput(cell: self, didUpdateFieldValue: text)
        }
    }
}
