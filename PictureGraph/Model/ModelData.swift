//
//  ModelData.swift
//  PictureGraph
//
//  Created by Ian Blaise on 3/31/22.
//

import Foundation
import SwiftUI

// This returns chunks size n from an array size m
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// Returns an array of screenshots (file name and creation date) sorted by creation date
func getScreenshots(screenshotsDirectory: URL?) -> [Screenshot] {
    let screenshotDirectory = "screenshots"
    var screenshots: [Screenshot] = []
    let fileManager = FileManager.default
    
    var documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        .first! // unwrap this safely
        .appendingPathComponent(screenshotDirectory)
    
    if let test = screenshotsDirectory {
        documentsURL = test
    }
    
    do {
        // get the pngs from the screenshot directory
        let directoryContents = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: [.creationDateKey]).filter{$0.pathExtension == "png" || $0.pathExtension == "jpg" || $0.pathExtension == "jpeg" }
        for item in directoryContents {
            // try to get the creation date for each item
            let resValues = try item.resourceValues(forKeys: [.creationDateKey])
            if let creationDate = resValues.creationDate {
                // create the Image object
                if let nsImage = NSImage(
                    contentsOf: item.absoluteURL)
                {
                    
                // insert new Screenshot to array
                    let ss = Screenshot(path: item.absoluteURL, date: creationDate, isLast: false, image: Image(nsImage: nsImage))
                screenshots.append(ss)
                }
            }
        }
        // return the array sorted by date
        var sorted = screenshots.sorted { $0.date < $1.date }
        if sorted.count > 0 {
        sorted[sorted.count - 1].isLast = true
        
        var numMissing = sorted.count % 4
        
        if numMissing != 0 {
            for i in 0..<numMissing {
                sorted.append(Screenshot(path: URL(string:"none")!, date: Date(), isLast: false, image: Image("transparent")))
            }
        }
        }
        
        return sorted
    } catch {
        print(error)
    }
    // return empty array
    return []
}
