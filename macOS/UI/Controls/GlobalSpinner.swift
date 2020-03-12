//
//  GlobalSpinner.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

// An NSProgressIndicator subclass that you can call GlobalSpinner.enqueue() and GlobalSpinner.dequeue()
// to start/stop the spinner as appropriate based on asynchronously executing tasks elsewhere in your app.
class GlobalSpinner: NSProgressIndicator {

    @IBOutlet weak var statusTextField: NSTextField?
    
    static let enqueueGlobalSpinnerNotification = NSNotification.Name(rawValue: "enqueueGlobalSpinnerNotification")
    static let dequeueGlobalSpinnerNotification = NSNotification.Name(rawValue: "dequeueGlobalSpinnerNotification")
    static let setGlobalSpinnerStatusNotification = NSNotification.Name(rawValue: "setGlobalSpinnerStatusNotification")

    var count = 0
    var status: String = "" {
        didSet {
            if count > 0 {
                statusTextField?.stringValue = status
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusTextField?.stringValue = status
        
        NotificationCenter.default.addObserver(self, selector: #selector(realEnqueue(_:)), name: GlobalSpinner.enqueueGlobalSpinnerNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(realDequeue(_:)), name: GlobalSpinner.dequeueGlobalSpinnerNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(realSetStatus(_:)), name: GlobalSpinner.setGlobalSpinnerStatusNotification, object: nil)
    }

    static func enqueue() {
        NotificationCenter.default.post(name: GlobalSpinner.enqueueGlobalSpinnerNotification, object: nil, userInfo: nil)
    }

    @objc func realEnqueue(_ notification: Notification) {
        count += 1
        if count > 0 {
            DispatchQueue.main.async {
                self.startAnimation(nil)
            }
        }
    }
    
    static func dequeue() {
        NotificationCenter.default.post(name: GlobalSpinner.dequeueGlobalSpinnerNotification, object: nil, userInfo: nil)
    }

    @objc func realDequeue(_ notification: Notification) {
        count -= 1
        if count <= 0 {
            count = 0
            DispatchQueue.main.async {
                self.statusTextField?.stringValue = ""
                self.stopAnimation(nil)
            }
        }
    }
    
    static func setStatus(_ string: String) {
        NotificationCenter.default.post(name: GlobalSpinner.setGlobalSpinnerStatusNotification, object: string)
    }
    
    @objc func realSetStatus(_ notification: Notification) {
        DispatchQueue.main.async {
            if let string = notification.object as? String {
                self.statusTextField?.stringValue = string
            } else {
                self.statusTextField?.stringValue = ""
            }
        }
    }
}
