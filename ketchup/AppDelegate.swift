//
//  ketchupApp.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 20/07/22.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSGestureRecognizerDelegate
{
    private var clipboard: ClipboardManager!
    private var statusItem: NSStatusItem!
    private var window: NSWindow!
    private var contentView: ContentView!
    private var menu: NSMenu!
    
    @Published var toggleTimeIndicatorUpdate: Bool = false
    
    func applicationDidFinishLaunching(_ notification: Notification)
    {
        clipboard = ClipboardManager()
        clipboard.delegate = self
        
        contentView = ContentView()
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [],
            backing: .buffered,
            defer: false
        )
        window.contentViewController = NSHostingController(rootView: contentView)
        window.level = .floating // makes the app always in front of other
        window.dismiss(animated: false)
        
        createStatusBar()
        
        // detects left mouse down outside of the window
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] event in
            self?.window.dismiss(animated: true)
        }
    }
    
    @objc func onStatusBarClicked()
    {
        guard let win = NSApplication.shared.windows.first,
              let event = NSApp.currentEvent
        else { return }
        
        // show menu on right mouse
        if event.type == .rightMouseUp
        {
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        }
        // display content view on left view
        else if event.type == .leftMouseUp
        {
            let dismissEvent = win.isVisible
            if dismissEvent
            {
                win.dismiss(animated: true)
                return;
            }
            // update the time indicator then present it
            contentView.viewModel.contents.forEach { $0.toggleTimeIndicatorUpdate() }
            win.present(animated: true)
        }
    }
    
    @objc func onQuit()
    {
        NSApplication.shared.terminate(self)
    }
    
    func createStatusBar()
    {
        // make status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button
        {
            button.image = NSImage(systemSymbolName: "pencil", accessibilityDescription: "Pencil")
            button.action = #selector(onStatusBarClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        menu = NSMenu()
        let menuItem1 = NSMenuItem(title: "Quit Ketchup", action: #selector(onQuit), keyEquivalent: "")
        menu.addItem(menuItem1)
    }
}

extension AppDelegate: ClipboardManagerDelegate
{
    func onNewContent(_ content: PasteboardContent)
    {
        contentView.viewModel.addContent(content)
    }
}

extension NSWindow
{
    func present(animated: Bool = true)
    {
        guard self.isVisible == false
        else { return }
        
        guard animated
        else
        {
            self.setFrameOrigin(CGPoint(x: 0, y: 0))
            self.makeKeyAndOrderFront(nil)
            return
        }
        
        self.setFrameOrigin(CGPoint(x: 0, y: -self.frame.height))
        self.makeKeyAndOrderFront(nil)
        
        let animation = CAKeyframeAnimation()
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        var origin = self.frame.origin
        origin.y += self.frame.height
        // path animation
        let path = CGMutablePath()
        path.move(to: origin)
        
        for i in stride(from: self.frame.origin.y, to: origin.y, by: 1) {
            path.addLine(to: CGPoint(x: 0, y: CGFloat(i)))
        }
        animation.path = path;
            
        self.animations = ["frameOrigin" : animation]
        self.animator().setFrameOrigin(origin)
    }
    
    func dismiss(animated: Bool = true)
    {
        guard self.isVisible
        else { return }
        
        guard animated
        else
        {
            self.orderOut(nil)
            return
        }
        
        let animation = CAKeyframeAnimation()
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        var origin = self.frame.origin
        origin.y -= self.frame.height
        // path animation
        let path = CGMutablePath()
        path.move(to: origin)
        
        for i in stride(from: self.frame.origin.y, to: origin.y, by: -1) {
            path.addLine(to: CGPoint(x: 0, y: CGFloat(i)))
        }
        animation.path = path;
        
        NSAnimationContext.runAnimationGroup({ context in
            self.animations = ["frameOrigin" : animation]
            self.animator().setFrameOrigin(origin)
        }, completionHandler: {
            self.orderOut(nil)
        })
    }
    
    func shakeWindow()
    {
        let numberOfShakes   = 3
        let durationOfShake  = 0.25
        let vigourOfShake    = 0.015

        let frame = self.frame
        let shakeAnimation = CAKeyframeAnimation()

        let shakePath = CGMutablePath()
        shakePath.move(to: CGPoint(x: frame.minX, y: frame.minY))

        for _ in 0...numberOfShakes-1 {
            shakePath.addLine(to: CGPoint(x: frame.minX - frame.size.width * vigourOfShake, y: frame.minY))
            shakePath.addLine(to: CGPoint(x: frame.minX + frame.size.width * vigourOfShake, y: frame.minY))
        }

        shakePath.closeSubpath()

        shakeAnimation.path = shakePath;
        shakeAnimation.duration = durationOfShake;

        self.animations = ["frameOrigin" : shakeAnimation]
        self.animator().setFrameOrigin(self.frame.origin)
    }
    
    func showAnimate(_ sender: Any?)
    {
        let isGoingDismissed = self.frame.origin.y >= 0
        // make sure the view is shown before animation hits
        self.makeKeyAndOrderFront(sender)
        // create animation
        let animation = CAKeyframeAnimation()
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: isGoingDismissed ? .easeIn : .easeOut)
        // this is the destination origin
        var origin = self.frame.origin
        origin.y += isGoingDismissed ? -self.frame.height : self.frame.height
        // path animation
        let path = CGMutablePath()
        path.move(to: origin)
        
        for i in stride(from: self.frame.origin.y, to: origin.y, by: isGoingDismissed ? -1 : 1) {
            path.addLine(to: CGPoint(x: 0, y: CGFloat(i)))
        }
        animation.path = path;

        self.animations = ["frameOrigin" : animation]
        self.animator().setFrameOrigin(origin)
    }
}
