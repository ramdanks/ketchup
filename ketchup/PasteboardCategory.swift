//
//  PasteboardCategory.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 27/07/22.
//

import Foundation
import AppKit

protocol PasteboardCategory
{
    var priority: Int { get }
    
    var types: [NSPasteboard.PasteboardType] { get }
}
