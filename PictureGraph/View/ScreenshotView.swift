//
//  ScreenshotView.swift
//  PictureGraph
//
//  Created by Ian Blaise on 4/1/22.
//

import SwiftUI

struct ScreenshotView: View {
    @State private var fileName: String = ""
    @State private var isVerticalGrid: Bool = true
    @State private var isHorizontalGrid: Bool = false
    @State private var isVerticalList: Bool = false
    @State private var isHorizontalList: Bool = false
    @State private var filename = "Filename"
    @State var lastScaleValue: CGFloat = 1.0
    @State var screenshots = getScreenshots(screenshotsDirectory: nil)
    
    let columns : Int = 5
    let rows : Int = 5
    
    var body: some View {
        //Bindings for toggles
        let verticalGridOn = Binding<Bool>(
            get: { self.isVerticalGrid },
            set: {
                self.isVerticalGrid = $0;
                self.isHorizontalGrid = false;
                self.isVerticalList = false;
                self.isHorizontalList = false
            }
        )
        let horizontalGridOn = Binding<Bool>(
            get: { self.isHorizontalGrid },
            set: {
                self.isHorizontalGrid = $0;
                self.isVerticalGrid = false;
                self.isVerticalList = false;
                self.isHorizontalList = false
            }
        )
        let verticalListOn = Binding<Bool>(
            get: { self.isVerticalList },
            set: {
                self.isVerticalList = $0;
                self.isHorizontalGrid = false;
                self.isVerticalGrid = false;
                self.isHorizontalList = false
            }
        )
        let horizontalListOn = Binding<Bool>(
            get: { self.isHorizontalList },
            set: {
                self.isHorizontalList = $0;
                self.isHorizontalGrid = false;
                self.isVerticalList = false;
                self.isVerticalGrid = false
                
            }
        )
        
        VStack (alignment: .leading){
            HStack {
                Text("**Filters**")
                    .padding()
                Divider()
                    .frame(height: 30)
                TextField("File name...",
                          text: $fileName
                )
                .padding()
                
                
            }
            .padding(.top)
            .padding(.leading)
            
            HStack {
                Text("**Views**")
                    .padding()
                Divider()
                    .frame(height:30)
                
                
                Text("Grid: ")
                
                Toggle(isOn: horizontalGridOn) {
                    Text("Vertical")
                }
                .toggleStyle(.button)
                
                
                Toggle(isOn: verticalGridOn) {
                    Text("Horizontal")
                }
                .toggleStyle(.button)
                
                Text("List: ")
                Toggle(isOn: verticalListOn) {
                    Text("Vertical")
                }
                .toggleStyle(.button)
                
                Toggle(isOn: horizontalListOn) {
                    Text("Horizontal")
                }
                .toggleStyle(.button)
                
                Spacer()
                
                Button("Choose Directory")
                {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = true
                    panel.canChooseFiles = false
                    
                    if panel.runModal() == .OK {
                        self.filename = panel.url?.lastPathComponent ?? "<none>"
                        screenshots = getScreenshots(screenshotsDirectory: panel.url)
                    }
                }
                .padding()
            }
            .padding(.leading)
            
            Divider()
            
            let screensFilteredPreSort = screenshots.filter {
                $0.path
                    .lastPathComponent
                    .lowercased()
                    .starts(with: fileName.lowercased())
            }
            
            let gridLayout = [GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 0),
                              GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 0),
                              GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 0),
                              GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 0)]
            
            let screensFiltered = sortedScreens(screenshots: screensFilteredPreSort, numChunks: gridLayout.count)
            
            if isVerticalGrid {
                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 0) {
                        ForEach(screensFiltered.indices, id: \.self) { index in
                            if(index < screensFiltered.count){
                                if screensFiltered[index].isLast { // isLastItem
                                    if !isEvenRow(index, screensFiltered.count) && !isLastItemInRow(index: index, numColumns: gridLayout.count){
                                        ScreenshotCard(horizontalArrow: "left", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                    } else {
                                    ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                    }
                                } else if isFirstItemInRow(index: index, numColumns: gridLayout.count) && isLastRow(index: index, numColumns: gridLayout.count, totalItems: screensFiltered.count) {
                                    if !isEvenRow(index, gridLayout.count) {
                                        if index == screensFiltered.count - 4 {
                                            ScreenshotCard(horizontalArrow: "left", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                        } else {
                                            ScreenshotCard(horizontalArrow: "left", verticalArrow: "down", index: index, screenshot: screensFiltered[index])
                                        }
                                    } else {
                                        ScreenshotCard(horizontalArrow: "right", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                    }
                                } else if isLastItemInRow(index: index, numColumns: gridLayout.count) && isEvenRow(index, screensFiltered.count){
                                    ScreenshotCard(horizontalArrow: "", verticalArrow: "down", index: index, screenshot: screensFiltered[index])
                                } else if isLastItemInRow(index: index, numColumns: gridLayout.count) && !isEvenRow(index, screensFiltered.count) {
                                    ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                } else if isEvenRow(index, screensFiltered.count){
                                    ScreenshotCard(horizontalArrow: "right", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                } else if !isEvenRow(index, screensFiltered.count) && isFirstItemInRow(index: index, numColumns: gridLayout.count) && !screensFiltered[index].isLast {
                                    ScreenshotCard(horizontalArrow: "left", verticalArrow: "down", index: index, screenshot: screensFiltered[index])
                                } else if !isEvenRow(index, screensFiltered.count) {
                                    ScreenshotCard(horizontalArrow: "left", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                }
                            }
                        }
                    }
                }
                .frame(minWidth: 600, idealWidth: 600, maxWidth: .infinity, minHeight: 600, idealHeight: 600, maxHeight: .infinity)
                .padding()
            } else if isHorizontalGrid {
                let gridLayoutH = [GridItem(.flexible(minimum: 150, maximum: .infinity), spacing: 0),
                                   GridItem(.flexible(minimum: 150, maximum: .infinity), spacing: 0),
                                   GridItem(.flexible(minimum: 150, maximum: .infinity), spacing: 0),
                                   GridItem(.flexible(minimum: 150, maximum: .infinity), spacing: 0)]
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridLayoutH, spacing: 0) {
                        ForEach(screensFiltered.indices, id: \.self) { index in
                            if(index < screensFiltered.count) {
                                if screensFiltered[index].isLast { // isLastItem
                                    if !isEvenRow(index, screensFiltered.count) && !isLastItemInRow(index: index, numColumns: gridLayoutH.count){
                                        ScreenshotCard(horizontalArrow: "", verticalArrow: "up", index: index, screenshot: screensFiltered[index])
                                    } else {
                                        ScreenshotCard(horizontalArrow: "", verticalArrow: "", index: index, screenshot: screensFiltered[index])
                                    }
                                } else if isFirstItemInRow(index: index, numColumns:  gridLayout.count) && isLastRow(index: index, numColumns: gridLayout.count, totalItems:screensFiltered.count) {
                                    if !isEvenRow(index, gridLayout.count) {
                                        if index == screensFiltered.count - 4 {
                                            ScreenshotCard(horizontalArrow: "", verticalArrow: "up", index: index, screenshot: screensFiltered[index])
                                        } else {
                                            ScreenshotCard(horizontalArrow: "right", verticalArrow: "up", index: index, screenshot: screensFiltered[index])
                                        }
                                    }
                                    else {
                                        ScreenshotCard(horizontalArrow: "", verticalArrow: "down", index: index, screenshot: screensFiltered[index])
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
                .frame(minWidth: 600, idealWidth: 600, maxWidth: .infinity, minHeight: 600, idealHeight: 600, maxHeight: .infinity)
                .padding()
            } else if isVerticalList { // Vertical list view
                List {
                    ForEach(screensFiltered.sorted { $0.date < $1.date }, id: \.self) { screenshot in
                        if screenshot.path.absoluteString != "none" {
                            ScreenshotVerticalListView(screenshot: screenshot)
                                .padding(.bottom, 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            } else { //Horizontal list view
                let adaptiveGridItems = [GridItem(.adaptive(minimum: 200))]
                
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: adaptiveGridItems, spacing: 0) {
                        ForEach(screensFiltered.sorted { $0.date < $1.date }, id: \.self) { screenshot in
                            if screenshot.path.absoluteString != "none" {
                                ScreenshotHorizontalListView(screenshot: screenshot)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                }
                .frame(minWidth: 500, idealWidth: .infinity, maxWidth: .infinity, minHeight: 500, idealHeight: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
    }
}

struct ScreenshotView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotView()
    }
}
