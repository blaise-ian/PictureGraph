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
        HStack {
            Image(systemName: "circle.fill")
            Text("screenshot.path.absolutePath")
            Button(action: {
                    print("hey")
            }) {
                Text("hi")
            }
        }
    }
}

struct ScreenshotListView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotListView()
    }
}
