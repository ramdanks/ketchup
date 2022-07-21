//
//  ContentView.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 20/07/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingCredits = false

        var body: some View {
            VStack {
                Button("Show Credits") {
                    showingCredits.toggle()
                }
                .sheet(isPresented: $showingCredits) {
                    Text("This app was brought to you by Hacking with Swift")
                }
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
                    NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
                    NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
                    NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
                })
            }
            .frame(width: NSScreen.main?.frame.width, height: 330, alignment: .center)
            
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
