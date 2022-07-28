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
                Color.white
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("112 characters")
                    .padding(8)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 200, height: 200)
    }
}

struct PasteboardView_Previews: PreviewProvider {
    static var previews: some View {
        PasteboardView(content: PasteboardContent(date: Date()))
    }
}
