//
//  ScreenshotCard.swift
//  PictureGraph
//
//  Created by Ian Blaise on 4/7/22.
//

import SwiftUI


struct ScreenshotCard: View {
    var horizontalArrow: String
    var verticalArrow:String
    var index: Int
    var screenshot: Screenshot?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if screenshot != nil {
                    
                    Button(action: {
                        print("Trying to open: ", screenshot!.path)
                        print("INDEX: ", index)
                        NSWorkspace.shared.open(screenshot!.path)
                        // Image arrangement (arrows)
                        // HOrizontal/ Vertical view
                        //QLPreviewPanel to open with Quick Look
                        // Designing cards
                        
                        // Look into resizing to make additional columns/ rows depending on size
                    }) {
                        VStack {
                        screenshot!.image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .shadow(radius: 5)
                            Text("\(index)")
                        }
                            
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help("\(screenshot!.path.lastPathComponent)")
                    
                } else {
                    Image("test-image")
                        .resizable()
                        .frame(width: 100, height:100)
                }
                ArrowShape(direction: horizontalArrow)
                    .stroke(lineWidth: 1)
                    .frame(minWidth: 50, minHeight: 20, maxHeight: 20)
                    .foregroundColor(.primary)
            }
            HStack {
                ArrowShape(direction: verticalArrow)
                    .stroke(lineWidth: 1)
                    .frame(minWidth: 20, maxWidth: 20, minHeight: 75)
                    .foregroundColor(.primary)
                    .padding(.leading, 50)
            }
        }
    }
}

struct ScreenshotCard_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotCard(horizontalArrow: "right", verticalArrow: "down", index: 5)
    }
}
