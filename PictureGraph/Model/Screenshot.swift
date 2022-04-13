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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(date)
    }
    
    var image: Image
}
