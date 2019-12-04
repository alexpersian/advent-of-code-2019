//
//  Computer.swift
//  AdventOfCode2019
//
//  Created by Alex Persian on 12/3/19.
//  Copyright © 2019 Alex Persian. All rights reserved.
//

import Foundation

enum OpCode: Int {
    case add = 1
    case mult = 2
    case end = 99
}

final class Computer {

    @SetOnce private var instructionSet: [Int]

    init() {
        instructionSet = loadInstructions()
    }

    private func loadInstructions() -> [Int] {
        // Load in the intcodes from the file storage
        guard
            let path = Bundle.main.path(forResource: "intcode-commands", ofType: "txt"),
            let data = try? String(contentsOfFile: path, encoding: .utf8)
            else { fatalError("Unable to read input file.") }

        // Break up the loaded strings into integers
        return data
            .components(separatedBy: ",")
            .compactMap { Int($0) }
    }

    private func performOperation(codes: [Int], start: Int) -> (p1: Int, p2: Int, p3: Int) {
        let p1 = codes[codes[start + 1]]
        let p2 = codes[codes[start + 2]]
        let p3 = codes[start + 3]
        return (p1, p2, p3)
    }

    func run(noun: Int, verb: Int) -> Int {
        // Load starting computer state
        var intCodes = instructionSet // Make a copy to perform operations on
        intCodes[1] = noun
        intCodes[2] = verb

        let jump = 4
        var index = 0

        while index < intCodes.count {
            switch intCodes[index] {
            case OpCode.add.rawValue:
                let result = performOperation(codes: intCodes, start: index)
                intCodes[result.p3] = result.p1 + result.p2
                index += jump
            case OpCode.mult.rawValue:
                let result = performOperation(codes: intCodes, start: index)
                intCodes[result.p3] = result.p1 * result.p2
                index += jump
            case OpCode.end.rawValue:
                return intCodes[0] // Return final result at address 0
            default:
                fatalError("Invalid intcode encountered.")
            }
        }

        fatalError("Reached end of input without terminating program.")
    }

    func find(result: Int) -> (noun: Int, verb: Int)? {
        let maxInput = 99
        var testNoun: Int = 0

        // Go through all of the possible permutations of noun and
        // verb input pairs to see if the desired result is found.
        while testNoun <= maxInput {
            for i in 0...maxInput {
                if run(noun: testNoun, verb: i) == result {
                    return (testNoun, i) // Pair found
                }
            }
            testNoun += 1
        }

        return nil // Failure to find a valid pair of inputs
    }
}
