//
//  ScreenshotListView.swift
//  PictureGraph
//
//  Created by Ian Blaise on 4/13/22.
//

import SwiftUI

struct ScreenshotListView: View {
    var screenshot: Screenshot?
    var body: some View {
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
            HStack {
                screenshot?.image
                    .resizable()
                    .frame(width: 100, height: 100)
                VStack (alignment: .leading){
                    if let screen = screenshot {
                        Text("File name: " + screen.path.lastPathComponent)
                        Text("Date created: " + screen.dateString())
                        Text("Time created: " + screen.timeString())
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ScreenshotListView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotListView()
    }
}
