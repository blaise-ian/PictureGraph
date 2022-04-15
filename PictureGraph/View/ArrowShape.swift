//
//  ArrowShape.swift
//  PictureGraph
//
//  Created by Ian Blaise on 4/15/22.
//

import Foundation
import SwiftUI

struct ArrowShape: Shape {
    var direction: String
    
    func path(in rect: CGRect) -> Path {
        let delta = rect.height / 3
        let delta2 = rect.width / 3
        return Path { path in
            if direction == "right" {
                path.move(to: CGPoint(x: 0, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                
                path.move(to: CGPoint(x: rect.maxX - delta, y: rect.midY - delta))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX - delta, y: rect.midY + delta))
            } else if direction == "left" {
                path.move(to: CGPoint(x: 0, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                
                path.move(to: CGPoint(x: delta, y: rect.midY - delta))
                path.addLine(to: CGPoint(x: 0, y: rect.midY))
                path.addLine(to: CGPoint(x:  delta, y: rect.midY + delta))
            } else if direction == "up" {
                path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX, y: 0))
                
                path.move(to: CGPoint(x: rect.midX - delta2, y: delta2))
                path.addLine(to: CGPoint(x: rect.midX, y: 0))
                path.addLine(to: CGPoint(x: rect.midX + delta2, y: delta2))
            } else if direction == "down" {
                path.move(to: CGPoint(x: rect.midX, y: 0))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                
                path.move(to: CGPoint(x: rect.midX - delta2, y: rect.maxY - delta2))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX + delta2, y: rect.maxY - delta2))
            } else {
                //print("Invalid direction")
            }
        }
    }
}
