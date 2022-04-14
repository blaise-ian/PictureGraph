//
//  ScreenshotListView.swift
//  PictureGraph
//
//  Created by Ian Blaise on 4/13/22.
//

import SwiftUI

struct ScreenshotVerticalListView: View {
    var screenshot: Screenshot?
    var body: some View {
        if let screen = screenshot {
            Button(action: {
                NSWorkspace.shared.open(screen.path)
            }) {
                HStack {
                    screen.image
                        .resizable()
                        .frame(width: 100, height: 100)
                    VStack (alignment: .leading){
                        
                        Text("File name: " + screen.path.lastPathComponent)
                        Text("Date created: " + screen.dateString())
                        Text("Time created: " + screen.timeString())
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ScreenshotListView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotVerticalListView()
    }
}
