//
//  RocketFueler.swift
//  AdventOfCode2019
//
//  Created by Alex Persian on 12/2/19.
//  Copyright © 2019 Alex Persian. All rights reserved.
//

import Foundation

final class RocketFueler {

    /// Calculates the total amount of fuel required for the rocket with all modules onboard.
    func getRequiredFuel() -> Int {
        // Load in the module masses from the file storage
        guard
            let path = Bundle.main.path(forResource: "module-masses", ofType: "txt"),
            let data = try? String(contentsOfFile: path, encoding: .utf8)
            else { fatalError("Unable to read input file.") }

        // Break up the loaded strings into integers
        let moduleMasses = data
            .components(separatedBy: .newlines)
            .compactMap { Int($0) }

        // Calculate all of the fuel require for each module
        // then combine all calculation into final fuel requirement
        return moduleMasses
            .map { calculateFuel(for: $0) }
            .reduce(0, +)
    }

    private func calculateFuel(for mass: Int) -> Int {
        let extra = mass / 3 - 2
        guard extra > 0 else { return 0 }
        return extra + calculateFuel(for: extra)
    }
}
