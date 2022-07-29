//
//  PasteboardContent.swift
//  ketchup
//
//  Created by Ramadhan Kalih Sewu on 27/07/22.
//

import Foundation
import AppKit

class PasteboardContent: ObservableObject, Identifiable
{
    private static var appIconDict: Dictionary<String, NSImage> = [:]
    
    private static var idIncrementingValue: UInt = 0
    
    @Published var timeIndicatorToggle: Bool = false
    
    var id: UInt
    
    var date: Date
    
    var content: String?
    
    var appBundleIdentifier: String?
    
    var icon: NSImage? { get {
        guard let bundleIdentifier = appBundleIdentifier
        else { return nil }
        return PasteboardContent.appIconDict[bundleIdentifier]
    }}
    
    var dateTextIndicator: String { get {
        let now = Date()
        let comp = Calendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfMonth, .month, .year], from: date, to: now)
        
        if let year = comp.year, year > 0           { return "\(year) years ago" }
        if let month = comp.month, month > 0        { return "\(month) months ago" }
        if let week = comp.weekOfMonth, week > 0    { return "\(week) weeks ago" }
        if let day = comp.day, day > 0              { return "\(day) days ago" }
        if let hour = comp.hour, hour > 0           { return "\(hour) hours ago" }
        if let minute = comp.minute, minute > 0     { return "\(minute) minutes ago"}
        if let second = comp.second, second > 3     { return "\(second) seconds ago" }
        
        return "now"
    }}
    
    public init(date: Date, content: String?, appBundleIdentifier: String? = nil, appIcon: NSImage? = nil)
    {
        self.date = date
        self.content = content
        self.appBundleIdentifier = appBundleIdentifier
        self.id = PasteboardContent.idIncrementingValue
        
        // auto incrementing id, each new object is different kind of object
        PasteboardContent.idIncrementingValue += 1
        
        guard let icon = appIcon,
              let bundleIdentifier = appBundleIdentifier
        else { return }
        // insert app icon to dictionary when it not nulls
        PasteboardContent.appIconDict[bundleIdentifier] = icon
    }
    
    public func toggleTimeIndicatorUpdate()
    {
        timeIndicatorToggle.toggle()
    }
}
