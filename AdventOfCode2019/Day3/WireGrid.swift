//
//  WireGrid.swift
//  AdventOfCode2019
//
//  Created by Alex Persian on 12/3/19.
//  Copyright © 2019 Alex Persian. All rights reserved.
//

import Foundation
import simd

struct Point {
    let x: Int
    let y: Int
}

struct LineSegment {
    let start: Point
    let end: Point
}

enum Direction {
    case up, down, right, left
}

struct Command {
    let direction: Direction
    let distance: Int

    init(_ string: String) {
        var _string = string
        let command = _string.removeFirst()

        switch command {
        case "U":
            direction = .up
        case "D":
            direction = .down
        case "R":
            direction = .right
        case "L":
            direction = .left
        default:
            fatalError("Unexpected command found in input.")
        }

        distance = Int(_string)!
    }
}

final class WireGrid {

    @SetOnce private var wireOneSegments: [LineSegment]
    @SetOnce private var wireTwoSegments: [LineSegment]

    init() {
        loadWirePaths()
    }

    // MARK: Private

    private func loadWirePaths() {
        // Load in the wire paths from the file storage
        let data = Bundle.loadFile(name: "wire-segments")

        // Break up the loaded String into two sections
        let wirePaths = data.components(separatedBy: .newlines).dropLast()

        // Separate each path into individual direction commands
        let allCommands = wirePaths.compactMap { $0.components(separatedBy: ",") }
        let firstPathCommands = allCommands[0].compactMap { Command($0) }
        let secondPathCommands = allCommands[1].compactMap { Command($0) }

        // Build a list of segments using the provided commands
        wireOneSegments = calculatePathSegments(for: firstPathCommands)
        wireTwoSegments = calculatePathSegments(for: secondPathCommands)
    }

    private func calculatePathSegments(for path: [Command]) -> [LineSegment] {
        var origin = Point(x: 0, y: 0)
        var segments: [LineSegment] = []

        for c in path {
            var newPoint: Point = origin
            var newSegment: LineSegment
            switch c.direction {
            case .up:
                newPoint = Point(x: origin.x, y: origin.y + c.distance)
                newSegment = LineSegment(start: origin, end: newPoint)
            case .down:
                newPoint = Point(x: origin.x, y: origin.y - c.distance)
                newSegment = LineSegment(start: origin, end: newPoint)
            case .right:
                newPoint = Point(x: origin.x + c.distance, y: origin.y)
                newSegment = LineSegment(start: origin, end: newPoint)
            case .left:
                newPoint = Point(x: origin.x - c.distance, y: origin.y)
                newSegment = LineSegment(start: origin, end: newPoint)
            }

            segments.append(newSegment)
            origin = newPoint
        }

        return segments
    }

    private func findIntersection(seg1: LineSegment, seg2: LineSegment) -> Point? {
        // Grabbed algorithm straight from https://stackoverflow.com/a/55315210/3434244
        let p1 = simd_double2(Double(seg1.start.x), Double(seg1.start.y))
        let p2 = simd_double2(Double(seg1.end.x), Double(seg1.end.y))
        let p3 = simd_double2(Double(seg2.start.x), Double(seg2.start.y))
        let p4 = simd_double2(Double(seg2.end.x), Double(seg2.end.y))

        let matrix = simd_double2x2(p4 - p3, p1 - p2)
        guard matrix.determinant != 0 else { return nil }
        let multipliers = matrix.inverse * (p1 - p3)
        guard (0.0 ... 1.0).contains(multipliers.x) && (0.0 ... 1.0).contains(multipliers.y) else { return nil }
        let result = p1 + multipliers.y * (p2 - p1)
        return Point(x: Int(result.x), y: Int(result.y))
    }

    private func distance(p1: Point, p2: Point) -> Int {
        // Manhattan distance is equivalent to |𝑎−𝑐|+|𝑏−𝑑|
        // where (a,b) is the starting point and (c,d) is the ending point.
        return abs(p1.x - p2.x) + abs(p1.y - p2.y)
    }

    // MARK: Public

    func findNearestIntersection(to origin: Point) -> (Int, Int) {
        var intersections: [(Point, Int)] = []
        var shortestDistance: Int = Int.max
        var shortestJumps: Int = Int.max
        var w1Steps = 0
        var w2Steps = 0

        // Traverse every segment of the wires individually
        for s1 in wireOneSegments {
            w2Steps = 0 // Reset steps for Wire2 each time we move to the next Wire1 segment
            for s2 in wireTwoSegments {
                // If we find an intersection, find the length from the start of
                // each segment to the intersection point, then add those respective
                // lengths to each wire's step counts before recording the data.
                if let i = findIntersection(seg1: s1, seg2: s2) {
                    let j = w1Steps + distance(p1: s1.start, p2: i)
                    let k = w2Steps + distance(p1: s2.start, p2: i)
                    intersections.append((i, j + k))
                }
                // Always add the full segment length to Wire2's before continuing
                w2Steps += distance(p1: s2.start, p2: s2.end)
            }
            // Always add the full segment length to Wire1's steps before continuing
            w1Steps += distance(p1: s1.start, p2: s1.end)
        }

        // Find the closest intersection point along with the one that
        // has the shortest path to it.
        intersections.forEach {
            let d = distance(p1: origin, p2: $0.0)
            if d < shortestDistance { shortestDistance = d }
            if $0.1 < shortestJumps { shortestJumps = $0.1 }
        }

        return (shortestDistance, shortestJumps)
    }
}
