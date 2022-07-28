//
//  ContentView.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 20/07/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.contents.isEmpty
            {
                Text("You Haven't Capture Any Content")
            }
            else
            {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        Color.clear
                            .frame(width: 0)
                        // newest content always placed from the tail of the list
                        // we want to display them first (top most left / leading)
                        ForEach(viewModel.contents.reversed()) { content in
                            PasteboardView(content: content)
                                .background(Color.white)
                                .cornerRadius(10, antialiased: true)
                        }
                        Color.clear
                            .frame(width: 0)
                    }
                }
            }
            
            Spacer()
        }
        .frame(width: NSScreen.main?.frame.width, height: 330, alignment: .center)
        .background(.ultraThinMaterial)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
            NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
            NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
            NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
