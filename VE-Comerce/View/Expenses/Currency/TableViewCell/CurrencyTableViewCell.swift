//
//  CurrencyTableViewCell.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 25.01.2022.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(currency: String) {
        self.currencyLabel.text = currency
    }
}
