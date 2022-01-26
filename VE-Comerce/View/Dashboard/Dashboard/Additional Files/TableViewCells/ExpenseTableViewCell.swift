//
//  ExpenseTableViewCell.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 26.01.2022.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell, NibLoadable, Reusable {
    
    @IBOutlet weak var expenseImageView: UIImageView! {
        didSet {
            expenseImageView.backgroundColor = .darkGem.withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            amountLabel.textColor = .darkGem
            amountLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
    }
    @IBOutlet weak var issueDateLabel: UILabel! {
        didSet {
            issueDateLabel.textColor = .darkGem
            issueDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
    }
    @IBOutlet weak var paymentDateLabel: UILabel! {
        didSet {
            paymentDateLabel.textColor = .darkGem
            paymentDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.expenseImageView.image = nil
        self.amountLabel.text = nil
        self.issueDateLabel.text = nil
        self.paymentDateLabel.text = nil
    }
    
    private func setupUI() {
        expenseImageView.layer.cornerRadius = 10
        backgroundColor = .solitude
    }
    
    func configure(expense: Expense) {
        if let imagePath = expense.image {
            let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
           if let imageUrl = docUrl?.appendingPathComponent(imagePath),
              let imageData = try? Data(contentsOf: imageUrl) {
            self.expenseImageView.image = UIImage(data: imageData)
           }
        }
        self.amountLabel.text = "TOTAL: \(expense.totalWithCurrency)"
        self.issueDateLabel.text = "ISSUE DATE: \(expense.issueDateString ?? "N/A")"
        if let paymentDateStr = expense.paymentDateString {
            paymentDateLabel.text = "PAYMENT DATE: \(paymentDateStr)"
        } else {
            paymentDateLabel.text = nil
        }
    }
}
