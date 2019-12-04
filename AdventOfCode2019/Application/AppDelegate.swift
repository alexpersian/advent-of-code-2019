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
            print("""
            Necessary inputs found...
              Noun: \(inputs.noun)
              Verb: \(inputs.verb)
            """)
        }

        NSApplication.shared.terminate(nil)
    }
}
