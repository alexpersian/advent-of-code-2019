//
//  PasswordCracker.swift
//  AdventOfCode2019
//
//  Created by Alex Persian on 12/6/19.
//  Copyright © 2019 Alex Persian. All rights reserved.
//

import Foundation

final class PasswordCracker {

    func optionsInRange(start: Int, end: Int) -> Int {
        var options: Int = 0
        for guess in start...end {
            if isValid(pass: guess) { options += 1 }
        }
        return options
    }

    private func isValid(pass: Int) -> Bool {
        var hasValidAdjacent: Bool = false
        var doubles: Set<Int> = Set()

        let digits: [Int] = String(pass).compactMap { $0.wholeNumberValue }

        for (i, x) in digits.enumerated() {
            guard i + 1 < digits.count else { break }
            let y = digits[i + 1]
            guard x <= y else { return false }
            if x == y {
                if !doubles.contains(x) {
                    hasValidAdjacent = true
                    doubles.insert(x)
                } else {
                    hasValidAdjacent = false
                }
            }
        }

        return hasValidAdjacent
    }
}
