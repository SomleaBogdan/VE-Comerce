//
//  UITableViewCell+Extension.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import Foundation

import UIKit

extension UITableViewCell {
    static let emptyCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "emptyCell")
        cell.textLabel?.text = "Empty Cell"
        return cell
    }()
}
