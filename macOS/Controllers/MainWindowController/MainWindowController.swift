//
//  MainWindowController.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    static var shared: MainWindowController!

    override func windowDidLoad() {
        super.windowDidLoad()
        MainWindowController.shared = self
        setupView()
    }

    func setupView() {
        window?.recalculateKeyViewLoop()
    }
}
