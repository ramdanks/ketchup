//
//  ClipboardManager.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 27/07/22.
//

import Foundation
import AppKit
import SwiftUI

protocol ClipboardManagerDelegate: AnyObject
{
    func onNewContent(_ content: PasteboardContent)
}

class ClipboardManager: NSObject
{
    public weak var delegate: ClipboardManagerDelegate?
    
    private var pause: Bool = false
    
    private let sound: NSSound?
    
    private let updateIntervalMillis: Double = 10.0
    
    private var timer: Timer?
    
    private var prevCount: Int
    
    private var prevPasteboardItem: NSPasteboardItem?
    
    override init()
    {
        prevCount = NSPasteboard.general.changeCount
        let asset = NSDataAsset(name: "SoundCopyEvent")
        sound = asset == nil ? nil : NSSound(data: asset!.data)
        
        super.init()
        
        let updateTimeInterval: TimeInterval = updateIntervalMillis / 1e3
        timer = Timer.scheduledTimer(timeInterval: updateTimeInterval, target: self, selector: #selector(checkForChangesInPasteboard), userInfo: nil, repeats: true)
    }
    
    func setString(_ string: String, forType dataType: NSPasteboard.PasteboardType) -> Bool
    {
        self.pause = true
        NSPasteboard.general.clearContents()
        let ret = NSPasteboard.general.setString(string, forType: dataType)
        prevCount = NSPasteboard.general.changeCount
        self.pause = false
        return ret
    }
}

extension ClipboardManager
{
    @objc private func checkForChangesInPasteboard()
    {
        let currCount = NSPasteboard.general.changeCount
        guard currCount != prevCount,
              pause == false
        else { return }
        
        guard let currItem = NSPasteboard.general.pasteboardItems?.first,
              currItem.isEqual(to: prevPasteboardItem) == false
        else { return }
        
        if let sound = sound, sound.isPlaying { sound.stop() }
        sound?.play()
        
        let frontApp = NSWorkspace.shared.frontmostApplication
        let bundleIdentifier = frontApp?.bundleIdentifier
        
        let content = PasteboardContent(
            date: Date(),
            content: currItem.string(forType: .string),
            appBundleIdentifier: bundleIdentifier,
            appIcon: frontApp?.icon
        )
        delegate?.onNewContent(content)
        
        // set for faster lookup than iterating throught the array
        let set = Set<NSPasteboard.PasteboardType>(currItem.types)
        
        prevPasteboardItem = currItem
        prevCount = currCount
    }
}
