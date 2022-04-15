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
                Toggle(isOn: verticalGridOn) {
                    Text("Vertical")
                }
                .toggleStyle(.button)
                
                Toggle(isOn: horizontalGridOn) {
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
            
            // 2. Try to make this scrollview zoomable
            //    -- Work on scaling the frame size up and down with the window size
            // 3. Create a browse folder option to load images from selected folder
            //    -- no files found should show if the directory is empty
            // 1. add two more views
            //    -- List Vertical/Horizontal
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
                let gridLayoutH = [GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 0),
                                   GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 0),
                                   GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 0),
                                   GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 0)]
                
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
                .frame(minWidth: 600, idealWidth: 1000, maxWidth: .infinity, minHeight: 600, idealHeight: 600, maxHeight: .infinity)
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
                ScrollView(.horizontal) {
                    HStack {
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
