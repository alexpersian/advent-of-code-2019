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
        print("Intcode:", computer.run())

        NSApplication.shared.terminate(nil)
    }
}
