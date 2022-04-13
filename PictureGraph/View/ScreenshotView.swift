//
//  ScreenshotView.swift
//  PictureGraph
//
//  Created by Ian Blaise on 4/1/22.
//

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

struct ScreenshotView: View {
    @State private var fileName: String = ""
    @State private var isVertical: Bool = false
    let columns : Int = 5
    let rows : Int = 5
    
    let screenshots = getScreenshots()
    
    func isEvenRow(_ index: Int, _ arrSize: Int) -> Bool {
        let numRows = arrSize / 4 + 1
        print("Index: " , index, "Num rows: ", numRows, " is even: ", index / 3 % 2)
        return index / 4 % 2 == 0
    }
    
    func isLastRow(index: Int, numColumns: Int, totalItems: Int) -> Bool {
        var totalRows = totalItems / numColumns
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
    
    var body: some View {
        VStack {
            HStack {
                Text("**Filters**")
                    .padding()
                Divider()
                    .frame(height: 30)
                TextField("File name...",
                          text: $fileName
                )
                .padding()
                Toggle(isOn: $isVertical) {
                    Text("Vertical")
                }
                .toggleStyle(.button)
                .padding(.trailing)
                
            }
            .padding()
            
            Divider()
            
            let screensFilteredPreSort = screenshots.filter {
                $0.path
                    .lastPathComponent
                    .lowercased()
                    .starts(with: fileName.lowercased())
            }
            
            let gridLayout = [GridItem(.flexible(), spacing: 0),
                              GridItem(.flexible(), spacing: 0),
                              GridItem(.flexible(), spacing: 0),
                              GridItem(.flexible(), spacing: 0)]
            
            let screensFiltered = sortedScreens(screenshots: screensFilteredPreSort, numChunks: gridLayout.count)
            
            if isVertical {
                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 0) {
                        ForEach(screensFiltered.indices, id: \.self) { index in
                            if(index < screensFiltered.count){
                                
                                if index == screensFiltered.count - 1 { // isLastItem
                                    ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                } else if isFirstItemInRow(index: index, numColumns: gridLayout.count) && isLastRow(index: index, numColumns: gridLayout.count, totalItems: screensFiltered.count) {
                                    if !isEvenRow(index, gridLayout.count) {
                                        ScreenshotCard(horizontalArrow: "left", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                    } else {
                                        ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                    }
                                } else if isLastItemInRow(index: index, numColumns: gridLayout.count) && isEvenRow(index, screensFiltered.count){
                                    ScreenshotCard(horizontalArrow: "", verticalArrow: "down", index: index, screenshot: screensFiltered[index])
                                } else if isLastItemInRow(index: index, numColumns: gridLayout.count) && !isEvenRow(index, screensFiltered.count) {
                                    ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                } else if isEvenRow(index, screensFiltered.count){
                                    ScreenshotCard(horizontalArrow: "right", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                } else if !isEvenRow(index, screensFiltered.count) && isFirstItemInRow(index: index, numColumns: gridLayout.count) {
                                    ScreenshotCard(horizontalArrow: "left", verticalArrow: "down", index: index, screenshot: screensFiltered[index])
                                } else if !isEvenRow(index, screensFiltered.count) {
                                    ScreenshotCard(horizontalArrow: "left", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                }
                            }
                        }
                        
                    }
                }
                .frame(width: 800, height: 600)
                .padding()
            } else {
                let gridLayoutH = [GridItem(.flexible(), spacing: 0),
                                  GridItem(.flexible(), spacing: 0),
                                  GridItem(.flexible(), spacing: 0),
                                  GridItem(.flexible(), spacing: 0)]
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridLayoutH, spacing: 0) {
                        ForEach(screensFiltered.indices, id: \.self) { index in
                            if(index < screensFiltered.count) {
                                
                                if index == screensFiltered.count - 1 { // isLastItem
                                ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                            } else if isFirstItemInRow(index: index, numColumns:  gridLayout.count) && isLastRow(index: index, numColumns: gridLayout.count, totalItems:screensFiltered.count) {
                                if !isEvenRow(index, gridLayout.count) {
                                    ScreenshotCard(horizontalArrow: "", verticalArrow: "up", index: index, screenshot: screensFiltered[index])
                                    
                                }
                                else {
                                    ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                }
                            } else if isLastItemInRow(index: index, numColumns: gridLayout.count) && isEvenRow(index, screensFiltered.count){
                                ScreenshotCard(horizontalArrow: "right", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                            } else if isLastItemInRow(index: index, numColumns: gridLayout.count) && !isEvenRow(index, screensFiltered.count) {
                                ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                            } else if isEvenRow(index, screensFiltered.count) {
                                ScreenshotCard(horizontalArrow: "", verticalArrow: "down", index: index, screenshot: screensFiltered[index])
                            } else if !isEvenRow(index, screensFiltered.count) && isFirstItemInRow(index: index, numColumns: gridLayout.count){
                                ScreenshotCard(horizontalArrow: "right", verticalArrow: "up", index: index, screenshot: screensFiltered[index])
                            } else if !isEvenRow(index, screensFiltered.count) {
                                ScreenshotCard(horizontalArrow: "", verticalArrow: "up", index: index, screenshot: screensFiltered[index])
                            }
                            }}
                    }
                }
                .frame(width: 800, height: 600)
                .padding()
            }
            
            
            
            
            
            
            
            
            
            
            /*
             ScrollView(.horizontal) {
             LazyHGrid(rows: gridItems, spacing: 0) {
             ForEach(0..<screensFiltered.count) { index in
             Button(action: {
             print("Trying to open: ", screensFiltered[index].path)
             print("INDEX: ", index)
             NSWorkspace.shared.open(screensFiltered[index].path)
             // Image arrangement (arrows)
             // HOrizontal/ Vertical view
             //QLPreviewPanel to open with Quick Look
             // Designing cards
             
             // Look into resizing to make additional columns/ rows depending on size
             }) {
             screensFiltered[index].image
             .resizable()
             .frame(width: 100, height: 75)
             .scaledToFit()
             .aspectRatio(contentMode: .fit)
             .overlay(
             RoundedRectangle(cornerRadius: 10)
             .stroke(.primary, lineWidth: 2)
             )
             }
             .buttonStyle(PlainButtonStyle())
             .help("\(screensFiltered[index].path.lastPathComponent)")
             
             /*
              if index != screensFiltered.count - 1 {
              
              if isEvenColumn(index) {
              ArrowShape(direction: "down")
              .stroke(lineWidth: 1)
              .frame(width: 20, height: 100)
              .foregroundColor(.primary)
              } else {
              ArrowShape(direction: "up")
              .stroke(lineWidth: 1)
              .frame(width: 20, height: 100)
              .foregroundColor(.primary)
              }
              }*/
             }
             }
             }*/
            
            /*
             ScrollView(.horizontal, showsIndicators: false) {
             HStack(spacing: 0) {
             let screensFiltered = screenshots.filter {
             $0.path
             .lastPathComponent
             .lowercased()
             .starts(with: fileName.lowercased())
             
             }
             
             ForEach(screensFiltered, id: \.self) { screenshot in
             // have to use NSImage to load from disk
             
             Button(action: {
             print("Trying to open: ", screenshot.path)
             NSWorkspace.shared.open(screenshot.path)
             // Image arrangement (arrows)
             // HOrizontal/ Vertical view
             //QLPreviewPanel to open with Quick Look
             // Designing cards
             
             // Look into resizing to make additional columns/ rows depending on size
             }) {
             screenshot.image
             .resizable()
             .frame(width: 100, height: 75)
             .scaledToFit()
             .aspectRatio(contentMode: .fit)
             .overlay(
             RoundedRectangle(cornerRadius: 10)
             .stroke(.primary, lineWidth: 2)
             )
             }
             .buttonStyle(PlainButtonStyle())
             .help("\(screenshot.path.lastPathComponent)")
             
             
             if screenshot != screensFiltered.last {
             ArrowShape(direction: "right")
             .stroke(lineWidth: 1)
             .frame(width: 100, height: 20)
             .foregroundColor(.primary)
             }
             // Lookup GeometryReader
             // move texts below image and use multiline
             // let fileName = screenshot.path.lastPathComponent
             // Text(fileName)
             
             }
             .frame(width: 100, height: 75)
             }
             
             }
             .padding()
             */
        }
        /*
         ScrollView {
         ZStack(alignment: .topLeading){
         LazyVGrid(columns: [
         GridItem(.fixed(50), spacing: 150),
         GridItem(.fixed(50), spacing: 150),
         GridItem(.fixed(50), spacing: 150),
         GridItem(.fixed(50), spacing: 150),
         GridItem(.fixed(50), spacing: 150)
         ],spacing: 100, content: {
         // if we found images..
         ForEach(screenshots, id: \.self) { screenshot in
         VStack {
         // have to use NSImage to load from disk
         
         if let nsImage = NSImage(
         contentsOf: screenshot.path) {
         Button(action: {
         print("Trying to open: ", screenshot.path)
         NSWorkspace.shared.open(screenshot.path)
         }) {
         GeometryReader { geo in
         
         VStack {
         Image(nsImage: nsImage)
         .resizable()
         .frame(width: 50, height: 100)
         .aspectRatio(contentMode: .fit)
         .padding()
         .cornerRadius(10)
         .shadow(radius: 4)
         Text("\(geo.frame(in: .global).midX)")
         .fixedSize()
         Text("\(geo.frame(in: .global).midY)")
         .fixedSize()
         }
         Path() { path in
         let posX = geo.frame(in: .global).midX
         let posY = geo.frame(in: .global).midY
         path.move(to: CGPoint(x: posX, y: posY))
         path.addLine(to: CGPoint(x: posX, y: posY))
         path.closeSubpath()
         }
         .stroke(Color.green, lineWidth: 5)
         
         
         
         }
         }
         .frame(width:50, height:100)
         .buttonStyle(PlainButtonStyle())
         .padding()
         }
         
         // Lookup GeometryReader
         // move texts below image and use multiline
         // let fileName = screenshot.path.lastPathComponent
         // Text(fileName)
         
         }
         }
         
         })
         }
         }
         */
    }
    
    
}

struct ScreenshotView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotView()
    }
}
