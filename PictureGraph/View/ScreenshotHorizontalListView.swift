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
            VStack(alignment: .leading) {
                screen.image
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("BLAH")
                Text("Blah")
                Text("BLAHHHH")
            }
        }
    }
}

struct ScreenshotHorizontalListView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotHorizontalListView()
    }
}
