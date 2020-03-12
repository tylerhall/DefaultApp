//
//  DateTextField.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import AppKit

// For macOS 10.15+...
// Set the .date property on this textfield and it will live update with the relative time since that
// date. Example: you'll see it count up from 1s, 2s, ... 1m, 2m, ... 1h, 2h, etc.
class DateTextField: NSTextField {

    static let df: DateFormatter = { let formatter = DateFormatter(); formatter.dateStyle = .medium; formatter.timeStyle = .medium; return formatter }()

    // We want our textfields to updated appropriately. So, those that are displaying recent dates that are
    // changing by the second will update more frequently. Those that only visually change every minute
    // are upated less often. This is just to prevent having a ton of textfields on screen at once (ex: in a table)
    // that are all doing work every second, forever.
    static let fastRefreshInterval: TimeInterval = 1 // How quickly the timer should repeat at the beginning.
    static let slowRefreshInterval: TimeInterval = 30 // How quickly the timer should repeat after it's been a while.

    static let buffer: TimeInterval = 2

    @available(OSX 10.15, *)
    static let rdf = RelativeDateTimeFormatter()

    var liveUpdateTimer: Timer?

    var date: Date? {
        didSet {
            if let date = self.date {
                if #available(OSX 10.15, *) {
                    self.setRelativeDate()
                    
                    let delta = Date().timeIntervalSince(date)
                    let liveUpdateInterval: TimeInterval = (delta < DateTextField.slowRefreshInterval) ? DateTextField.fastRefreshInterval : (DateTextField.slowRefreshInterval - DateTextField.buffer)
                    
                    liveUpdateTimer?.invalidate()
                    liveUpdateTimer = Timer.scheduledTimer(withTimeInterval: liveUpdateInterval, repeats: true, block: { (timer) in
                        let delta = Date().timeIntervalSince(date)
                        if delta > (DateTextField.slowRefreshInterval + DateTextField.buffer) {
                            self.date = date
                        }
                        self.setRelativeDate()
                    })
                } else {
                    self.stringValue = DateTextField.df.string(from: date)
                    self.toolTip = ""
                }
            } else {
                self.stringValue = ""
                self.toolTip = self.stringValue
            }
        }
    }

    @available(OSX 10.15, *)
    func setRelativeDate() {
        if let date = date {
            stringValue = DateTextField.rdf.localizedString(for: date, relativeTo: Date())
            toolTip = DateTextField.df.string(from: date)
        } else {
            self.stringValue = ""
            self.toolTip = self.stringValue
        }
    }
}
