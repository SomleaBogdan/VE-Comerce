//
//  AddExpensesSwitchTableViewCell.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

protocol AddExpensesSwitchCellDelegate: AnyObject {
    func addExpensesSwitch(cell: AddExpensesSwitchTableViewCell, didChangeSwitchValue newValue: Bool)
}

class AddExpensesSwitchTableViewCell: UITableViewCell, NibLoadable, Reusable {

    @IBOutlet weak var cellSwitch: UISwitch! {
        didSet {
            cellSwitch.onTintColor = .darkGem
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .darkGem
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
    }
    
    private weak var delegate: AddExpensesSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    func configure(field: AddExpensesFormField, delegate: AddExpensesSwitchCellDelegate) {
        self.delegate = delegate
        titleLabel.text = field.fieldType?.title
        if let value = field.value as? Bool {
            cellSwitch.isOn = value
        } else {
            cellSwitch.isOn = false
        }
    }
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        self.delegate?.addExpensesSwitch(cell: self, didChangeSwitchValue: sender.isOn)
    }
}
