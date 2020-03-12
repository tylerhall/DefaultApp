//
//  ASApp.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

// This subclass stands for "AppleScriptableApplication".
// It's a simple entry point to provide basic AppleScript
// capabilities to your app. Take a look at macOS/Resources/DefaultApp.sdef
class ASApplication: NSApplication {
    
    // This is just an example command to see how it relates to the
    // corresponding definition in macOS/Resources/DefaultApp.sdef
    func openMainWindow() {
        if let delegate = delegate as? AppDelegate {
            delegate.showMainWindow(nil)
        }
    }
}
