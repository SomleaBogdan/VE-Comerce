//
//  AddExpenseImageTableViewCell.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 25.01.2022.
//

import UIKit

class AddExpenseImageTableViewCell: UITableViewCell, NibLoadable, Reusable {

    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var expenseImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupImage(image: nil)
        titleLabel.text = nil
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        titleLabel.layer.borderColor = UIColor.darkGem.cgColor
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.cornerRadius = 15
        expenseImageView.layer.cornerRadius = 10
    }
    
    func configure(field: AddExpensesFormField) {
        setupImage(image: field.value)
        titleLabel.text = field.fieldType?.title
    }
    
    private func setupImage(image: Any?) {
        guard let titleLabelTopConstraint = titleLabelTopConstraint else {
            return
        }
        if let imageUrl = image as? String {
            NSLayoutConstraint.activate([titleLabelTopConstraint])
            expenseImageView.image = UIImage(contentsOfFile: imageUrl)
        } else if let image = image as? UIImage {
            expenseImageView.image = image
            NSLayoutConstraint.activate([titleLabelTopConstraint])
        } else {
            expenseImageView.image = nil
            NSLayoutConstraint.deactivate([titleLabelTopConstraint])
        }
    }
}
