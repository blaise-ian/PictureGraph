//
//  Screenshot.swift
//  PictureGraph
//
//  Created by Ian Blaise on 3/31/22.
//

import Foundation
import SwiftUI

struct Screenshot: Hashable {
    var path: URL
    var date: Date
    var isLast: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(date)
    }
    
    func timeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self.date)
    }
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        return dateFormatter.string(from: self.date)
    }
    var image: Image
}
