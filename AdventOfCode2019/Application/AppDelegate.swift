//
//  AppDelegate.swift
//  AdventOfCode2019
//
//  Created by Alex Persian on 12/2/19.
//  Copyright © 2019 Alex Persian. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Day 1
        let fueler = RocketFueler()
        print("Fuel required:", fueler.getRequiredFuel())
        
        // Day 2
        let computer = Computer()
        print("Intcode result:", computer.run(noun: 12, verb: 2))
        // Part two
        if let inputs = computer.find(result: 19690720) {
            print("Necessary inputs found... Noun: \(inputs.noun) Verb: \(inputs.verb)")
        }

        // Day 3
        let grid = WireGrid()
        let result = grid.findNearestIntersection(to: Point(x: 0, y: 0))
        print("Closest wire crossing:", result.0)
        print("Shortest wire crossing:", result.1)

        // Day 4
        let cracker = PasswordCracker()
        print("Number of options:", cracker.optionsInRange(start: 240298, end: 784956))

        // Terminate the program immediately so it behaves like a CLI project
        NSApplication.shared.terminate(nil)
    }
}

extension Bundle {
    /// Loads a text file from the bundle and returns it as a `String` to be used.
    /// - Parameters:
    ///   - name: Name of the text file to load
    /// - Returns: `String` representing the data within the text file with no formating done.
    class func loadFile(name: String) -> String {
        guard
            let path = Bundle.main.path(forResource: name, ofType: "txt"),
            let data = try? String(contentsOfFile: path, encoding: .utf8)
            else { fatalError("Unable to read input file.") }
        return data
    }
}

// Thanks Dave!
/// Property wrapper for a variable that prevents it from being set more than once.
/// This forces the behavior of a `let` declaration without requiring the value
/// to be set on initialization.
///
///  - Important: Attempting to set the value more than once will result in a `fatalError`!
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
