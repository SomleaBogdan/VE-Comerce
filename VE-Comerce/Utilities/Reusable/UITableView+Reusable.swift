//
//  UITableView+Reusable.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

extension UITableView {
    
    //Register Nib Based Cell
    final func register<T: UITableViewCell>(cellType: T.Type)
    where T: Reusable & NibLoadable {
        self.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<T: UITableViewCell>(cellType: T.Type)
    where T: Reusable {
        self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
    where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
}
