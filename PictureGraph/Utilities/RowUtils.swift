//
//  RowUtils.swift
//  PictureGraph
//
//  Created by Ian Blaise on 4/15/22.
//

import Foundation

func isEvenRow(_ index: Int, _ arrSize: Int) -> Bool {
    let numRows = arrSize / 4 + 1
    print("Index: " , index, "Num rows: ", numRows, " is even: ", index / 3 % 2)
    return index / 4 % 2 == 0
}

func isLastRow(index: Int, numColumns: Int, totalItems: Int) -> Bool {
    let totalRows = totalItems / numColumns
    print("Index/numcolumsn", index/numColumns, "returns: ", index / numColumns == totalRows)
    
    return index / numColumns + 1 == totalRows
}

func isLastItemInRow(index: Int, numColumns: Int) -> Bool {
    return (index+1) % numColumns == 0
}

func isFirstItemInRow(index: Int, numColumns: Int) -> Bool {
    return index % numColumns == 0
}

func sortedScreens(screenshots: [Screenshot], numChunks: Int) -> [Screenshot] {
    let result = screenshots.chunked(into: numChunks)
    
    var finalResult: [Screenshot] = []
    
    for(index, item) in result.enumerated()
    {
        if index % 2 == 0 {
            let res = item.sorted {$0.date < $1.date}
            finalResult += res
        } else {
            let res = item.sorted {$1.date < $0.date}
            finalResult += res
        }
    }
    return finalResult
}
