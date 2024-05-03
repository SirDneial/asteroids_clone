//
//  Constants.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 5/1/24.
//

import Foundation

func deg2rad(degrees: Double) -> Double {
    degrees * .pi / 180
}

func rad2deg(radians: Double) -> Double {
    radians * 180 / .pi
}

func findDestination(start: CGPoint, distance: CGFloat = 1152, angle: CGFloat) -> CGPoint {
    var x: Double = 0
    var y: Double = 0
    var angleInRadians: Double = 0
    angleInRadians = deg2rad(degrees: angle + 90)
    x = distance * cos(angleInRadians)
    y = distance * sin(angleInRadians)
    return CGPoint(x: start.x + x, y: start.y + y)
}
