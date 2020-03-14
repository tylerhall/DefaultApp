//
//  MenuBarStatusItem.swift
//  DefaultApp
//
//  Created by Tyler Hall on 3/14/20.
//  Copyright © 2020 Your Company. All rights reserved.
//

import AppKit

class MenuBarStatusItem {

    var statusItem: NSStatusItem?

    var clicked: (() -> ())?
    var controlClicked: (() -> ())?

    init() {
        installMenuItem()
    }

    func installMenuItem() {
        if statusItem == nil {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusItem?.button?.target = self
            statusItem?.button?.action = #selector(statusItemClicked(_:))
            statusItem?.button?.sendAction(on: [.leftMouseDown, .rightMouseDown])
        }
    }
    
    func removeStatusItem() {
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
        }
    }

    func setTitle(_ title: String?) {
        statusItem?.button?.title = title ?? ""
    }
    
    func setImage(_ image: NSImage?) {
        statusItem?.button?.image = image
    }
    
    func setImageNamed(_ imageName: String?) {
        if let imageName = imageName {
            let image = NSImage(named: imageName)
            setImage(image)
        } else {
            setImage(nil)
        }
    }

    // Note: Setting a popup menu will break the click handlers (for now).
    func setMenu(_ menu: NSMenu?) {
        statusItem?.menu = menu
    }
    
    func show() {
        statusItem?.isVisible = true
    }
    
    func hide() {
        statusItem?.isVisible = false
    }

    @objc @IBAction func statusItemClicked(_ sender: AnyObject?) {
        if let event = NSApp.currentEvent, event.isRightClick {
            controlClicked?()
        } else {
            clicked?()
        }
    }
}
