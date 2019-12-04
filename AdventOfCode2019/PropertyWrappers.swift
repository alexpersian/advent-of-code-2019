//
//  PropertyWrappers.swift
//  AdventOfCode2019
//
//  Created by Alex Persian on 12/3/19.
//  Copyright © 2019 Alex Persian. All rights reserved.
//

import Foundation

// Thanks Dave!
@propertyWrapper
struct SetOnce<T> {
    private var value: T?
    var wrappedValue: T {
        get { return value! }
        set {
            if value != nil { fatalError() }
            value = newValue
        }
    }
}
