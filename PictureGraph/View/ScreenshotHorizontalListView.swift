//
//  ScreenshotHorizontalListView.swift
//  PictureGraph
//
//  Created by Ian Blaise on 4/14/22.
//

import SwiftUI

struct ScreenshotHorizontalListView: View {
    var screenshot: Screenshot?
    
    var body: some View {
        if let screen = screenshot {
            Button(action: {
                NSWorkspace.shared.open(screen.path)
            }) {
                VStack(alignment: .leading) {
                    screen.image
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("File name: " + screen.path.lastPathComponent)
                    Text("Date created: " + screen.dateString())
                    Text("Time created: " + screen.timeString())
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 10)
        }
    }
}

struct ScreenshotHorizontalListView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotHorizontalListView()
    }
}
