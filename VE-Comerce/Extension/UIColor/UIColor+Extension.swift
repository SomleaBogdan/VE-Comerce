//
//  UIColor+Extension.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

extension UIColor {
    
    /**
        Colors named using https://www.color-blindness.com/color-name-hue/
     */
    
    static let lightPurple = #colorLiteral(red: 0.5568627451, green: 0.4862745098, blue: 0.7647058824, alpha: 1) //0x8e7cc3
    static let solitude = #colorLiteral(red: 0.9019607843, green: 0.9215686275, blue: 0.937254902, alpha: 1) //0xF5F7F9 //light gray
    static let blueCharcoal = #colorLiteral(red: 0.1529411765, green: 0.168627451, blue: 0.1960784314, alpha: 1) //0x272C32
    static let blueGem       = #colorLiteral(red: 0.2352941176, green: 0.2549019608, blue: 0.6392156863, alpha: 1) //0x3C41A3
    static let darkGem       = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3098039216, alpha: 1)
    
    //Used for debug only
    static var random: UIColor {

        let randomColor = UIColor(red: .random(),
                                  green: .random(),
                                  blue: .random(),
                                  alpha: 1.0)
        return randomColor
    }
}

//Used for debug only
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
