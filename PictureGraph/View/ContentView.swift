//
//  ContentView.swift
//  PictureGraph
//
//  Created by Ian Blaise on 3/31/22.
//

import SwiftUI


struct ContentView: View {
    func isEvenRow(_ index: Int, _ arrSize: Int) -> Bool {
        let numRows = arrSize / 3 + 1
        print("Index: " , index, "Num rows: ", numRows, " is even: ", index / 3 % 2)
        return index / 3 % 2 == 0
    }
    
    func isLastItemInRow(index: Int, numColumns: Int) -> Bool {
        return (index+1) % numColumns == 0
    }
    
    func isFirstItemInRow(index: Int, numColumns: Int) -> Bool {
        return index % numColumns == 0
    }
    
    var body: some View {
        //ScreenshotView()
        /*let gridLayout = [GridItem(.flexible(), spacing: 0),
                          GridItem(.flexible(), spacing: 0),
                          GridItem(.flexible(), spacing: 0)]
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 0) {
                ForEach(0..<204) { index in
                    if index == 203 { // isLastItem
                        ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index)
                    }
                    else if isLastItemInRow(index: index, numColumns: gridLayout.count) && isEvenRow(index, 203){
                        ScreenshotCard(horizontalArrow: "", verticalArrow: "down", index: index)
                    } else if isLastItemInRow(index: index, numColumns: gridLayout.count) && !isEvenRow(index, 203) {
                        ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index)
                    } else if isEvenRow(index, 203){
                        ScreenshotCard(horizontalArrow: "right", verticalArrow: "", index: index)
                    } else if !isEvenRow(index, 203) && isFirstItemInRow(index: index, numColumns: gridLayout.count) {
                        ScreenshotCard(horizontalArrow: "left", verticalArrow: "down", index: index)
                    } else if !isEvenRow(index, 203) {
                        ScreenshotCard(horizontalArrow: "left", verticalArrow: "", index: index)
                    }
                }
            }
        }
        .frame(width: 800, height: 600)
         */
        ScreenshotView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
