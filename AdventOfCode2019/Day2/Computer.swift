//
//  Computer.swift
//  AdventOfCode2019
//
//  Created by Alexander Persian  on 12/3/19.
//  Copyright © 2019 Alex Persian. All rights reserved.
//

import Foundation

enum OpCode: Int {
  case add = 1
  case mult = 2
  case end = 99
}

final class Computer {
  func run() -> Int {
    // Load in the intcodes from the file storage
    guard
        let path = Bundle.main.path(forResource: "intcode-commands", ofType: "txt"),
        let data = try? String(contentsOfFile: path, encoding: .utf8)
        else { fatalError("Unable to read input file.") }

    // Break up the loaded strings into integers
    var intCodes = data
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    // Restore previous computer state
    intCodes[1] = 12
    intCodes[2] = 2

    let jump = 4
    var index = 0

    while index < intCodes.count {
      switch intCodes[index] {
      case OpCode.add.rawValue:
        let result = performOperation(codes: intCodes, start: index)
        intCodes[result.2] = result.0 + result.1
        index += jump
      case OpCode.mult.rawValue:
        let result = performOperation(codes: intCodes, start: index)
        intCodes[result.2] = result.0 * result.1
        index += jump
      case OpCode.end.rawValue:
        print("PROGRAM COMPLETE")
        return intCodes[0]
      default:
        fatalError("Invalid intcode encountered.")
      }
    }

    fatalError("Reached end of input without terminating program.")
  }

  private func performOperation(codes: [Int], start: Int) -> (Int, Int, Int) {
    let i = codes[codes[start + 1]]
    let j = codes[codes[start + 2]]
    let o = codes[start + 3]
    return (i, j, o)
  }
}
