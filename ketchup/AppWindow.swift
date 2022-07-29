//
//  AppWindow.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 28/07/22.
//

import Foundation
import AppKit
import SwiftUI
import Combine

class AppWindow: NSWindow
{
    override var acceptsFirstResponder: Bool { return true }
    
    override func keyDown(with event: NSEvent)
    {
        super.keyDown(with: event)
        
        print("key down: \(event.keyCode)")
    }
    
    override func keyUp(with event: NSEvent)
    {
        super.keyUp(with: event)
    }
}
