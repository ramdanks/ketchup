//
//  PasteboardView.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 27/07/22.
//

import SwiftUI

struct PasteboardView: View {
    
    @ObservedObject var content: PasteboardContent
    
    var body: some View {
        ZStack {
            // header
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Spacer()
                        Text("Text")
                            .font(.system(size: 16))
                        Text(content.dateTextIndicator)
                            .font(.system(size: 10))
                        Spacer()
                    }
                    .padding([.leading], 10)
                    .frame(height: 60)
                    
                    Spacer()
                    
                }
                .background(Color.black)
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            
            // app icon overlay
            if let icon = content.icon
            {
                VStack {
                    HStack {
                        Spacer()
                        Image(nsImage: icon)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 100)
                            .padding([.top, .trailing], -20)
                    }
                    Spacer()
                }
            }
            
            // content
            VStack {
                Spacer(minLength: 60)
                
                ZStack(alignment: .leading)
                {
                    Color("ContentBackground")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack
                    {
                        Text(content.content ?? "")
                            .font(.system(size: 11))
                            .padding([.top, .leading, .trailing], 10)
                            .foregroundColor(Color("ContentForeground"))
                        
                        Spacer(minLength: 0)
                    }
                }
                    
                Text("\(content.content?.count ?? 0) characters")
                    .padding(8)
                    .font(.system(size: 10))
            }
        }
        .frame(width: 200, height: 200)
        .background(Color("ContentBackground"))
    }
}

struct PasteboardView_Previews: PreviewProvider {
    static var previews: some View {
        PasteboardView(content: PasteboardContent(date: Date(), content: "To elaborate on the two existing answers, there are a couple of approaches to making the background change based on light or dark mode (aka colorScheme) depending on what you're trying to achieve."))
    }
}
