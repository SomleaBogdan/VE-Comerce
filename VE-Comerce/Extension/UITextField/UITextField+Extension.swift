//
//  UITextField+Extension.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

enum PaddingSpace {
    case left(CGFloat)
    case right(CGFloat)
    case equalSpacing(CGFloat)
}

extension UITextField {
    var lightPlaceholder: String? {
        set(newValue) {
            self.attributedPlaceholder = NSAttributedString(string: newValue ?? "",
                                                            attributes:
                                                                [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.75)])
        }
        get {
            return self.placeholder
        }
    }
    
    func addPadding(padding: PaddingSpace) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true

        switch padding {

        case .left(let spacing):
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = leftPaddingView
            self.leftViewMode = .always

        case .right(let spacing):
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = rightPaddingView
            self.rightViewMode = .always

        case .equalSpacing(let spacing):
            let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = equalPaddingView
            self.leftViewMode = .always
            // right
            self.rightView = equalPaddingView
            self.rightViewMode = .always
        }
    }
}
