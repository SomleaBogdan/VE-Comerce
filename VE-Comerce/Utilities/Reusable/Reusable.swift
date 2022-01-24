//
//  Reusable.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 24.01.2022.
//

import UIKit

public protocol Reusable: AnyObject {
  
  static var reuseIdentifier: String { get }
}

public typealias NibReusable = Reusable

// MARK: - Default implementation

public extension Reusable {
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
