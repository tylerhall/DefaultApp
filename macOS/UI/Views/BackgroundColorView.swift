//
//  BackgroundColorView.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

// Ahh, yes. AppKit.
class BackgroundColorView: NSView {
    
    @IBInspectable var backgroundColor: NSColor! {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        backgroundColor.setFill()
        bounds.fill()
        super.draw(dirtyRect)
    }
}
