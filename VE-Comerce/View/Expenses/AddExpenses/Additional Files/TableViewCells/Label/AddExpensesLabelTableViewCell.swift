//
//  AddExpensesLabelTableViewCell.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit


class AddExpensesLabelTableViewCell: UITableViewCell, NibLoadable, Reusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(field: AddExpensesFormField) {
        
    }
}
