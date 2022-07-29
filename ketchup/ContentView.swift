//
//  ContentView.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 20/07/22.
//

import SwiftUI

struct ContentView: View
{
    @ObservedObject var viewModel = ViewModel()
    
    @State var selectedIndex: UInt = UInt.max
    
    @State private var isSearchFocused: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var filter: [Bool] = []
    
    var onContentSelected: ((PasteboardContent) -> Void)? = nil

    var body: some View {
        VStack {
            
            HStack {
                Button(
                    action: {
                        isSearchFocused.toggle()
                    },
                    label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 10, weight: .semibold))
                    }
                )
                .padding(16)
                
                if isSearchFocused
                {
                    TextField("Search...", text: $searchText)
                        .onSubmit {
                            print(searchText)
                            isSearchFocused.toggle()
                        }
                        .frame(width: 300)
                }
            }
            .textFieldStyle(.roundedBorder)
            
            Spacer()
            
//            Button("to oldest") {
//                withAnimation {
//                    if selectedIndex == UInt.max {
//                        selectedIndex = UInt(viewModel.contents.count - 1)
//                    }
//                    if selectedIndex > 0 {
//                        selectedIndex -= 1
//                    }
//                }
//            }
//
//            Button("to newest") {
//                withAnimation {
//                    if selectedIndex < viewModel.contents.count - 1 {
//                        selectedIndex += 1
//                    }
//                }
//            }
            
            if viewModel.contents.isEmpty
            {
                Text("You Haven't Capture any Content")
                    .font(.system(size: 24))
                    .shadow(radius: 2)
            }
            else
            {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        // to add spacing from scroll view to leading
                        Color.clear
                            .frame(width: 0)
                        // newest content always placed from the tail of the list
                        // we want to display them first (top most left / leading))
                        ForEach(viewModel.contents.indices.reversed(), id: \.self) { index in
                            ZStack {
                                Color.blue
                                    .opacity(selectedIndex == UInt.max && index == viewModel.contents.count - 1 ||
                                            index == selectedIndex ? 1 : 0)
                                    .frame(width: 210, height: 210)
                                    .cornerRadius(10, antialiased: true)
                                    .transition(.opacity)
                                    .animation(.linear, value: 0.25)
                                PasteboardView(content: viewModel.contents[index])
                                    .background(Color("ContentBackground"))
                                    .cornerRadius(10, antialiased: true)
                                    .onTapGesture {
                                        guard selectedIndex == UInt(index)
                                        else
                                        {
                                            withAnimation {
                                                selectedIndex = UInt(index)
                                            }
                                            return
                                        }
                                        let content = viewModel.contents[index]
                                        onContentSelected?(content)
                                    }
                            }
                        }
                        // add spacing from scroll view to trailing
                        Color.clear
                            .frame(width: 0)
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.ultraThinMaterial)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
            NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
            NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
            NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        })
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View {
        ContentView()
    }
}
