//
//  ViewModel.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 28/07/22.
//

import Foundation

class ViewModel: ObservableObject
{
    @Published var contents: Array<PasteboardContent> = []
    
    func addContent(_ content: PasteboardContent) { contents.append(content) }
}
