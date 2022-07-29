//
//  Application.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 28/07/22.
//

import Foundation
import AppKit

class Application: NSApplication
{
    let appDelegate = AppDelegate()
    
    override init()
    {
        super.init()
        self.delegate = appDelegate
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
