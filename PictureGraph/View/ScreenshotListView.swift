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
            screenshot?.image
                .resizable()
                .frame(minWidth: 50, idealWidth: 100, maxWidth: .infinity, minHeight: 50, idealHeight: 100, maxHeight: 200, alignment: .leading)
            Text((screenshot?.path.lastPathComponent)!)
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
