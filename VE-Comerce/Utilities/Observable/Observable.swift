//
//  Observable.swift
//  VE-Comerce
//
//  Created by Bogdan Somlea on 22.01.2022.
//

import Foundation

class Observable<T>: NSObject {
    typealias Listener = (T) -> Void
    var listeners: [Listener]
    
    var value: T? {
        didSet {
            for listener in listeners {
                guard let value = value else {
                    return
                }
                listener(value)
            }
        }
    }
    
    //MARK: - Constructor
    override init() {
        self.value = nil
        self.listeners = []
        
    }
    
    convenience init(_ value: T) {
        self.init()
        defer {
            self.value = value
        }
    }
    
    func observe(_ listener: Listener?) {
        guard let listener = listener else {
            return
        }
        listeners.append(listener)
    }
}
