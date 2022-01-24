//
//  AuthenticationButtonTableViewCell.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

class AuthenticationButtonTableViewCell: UITableViewCell, NibLoadable, Reusable {

    @IBOutlet weak var actionButton: UIButton! {
        didSet {
            actionButton.backgroundColor = .blueGem
            actionButton.setTitleColor(.solitude, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    func configure(field: AuthenticationFormField) {
        actionButton?.setTitle(field.fieldType?.title, for: .normal)
    }
}
