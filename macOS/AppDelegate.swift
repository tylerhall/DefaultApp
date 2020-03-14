//
//  AppDelegate.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

#if SPARKLE
import Sparkle
#endif

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // We need a reference to the "Check for Updates" menu item so we
    // can hide it in Mac App Store (non-Sparkle) builds.
    @IBOutlet weak var checkForUpdatesMenuItem: NSMenuItem!

    // My apps almost always have both of these window controllers. Substitute with your own.
    lazy var mainWindowController: MainWindowController = { MainWindowController(windowNibName: String(describing: MainWindowController.self)) }()
    lazy var prefsWindowController: PrefsWindowController = { PrefsWindowController(windowNibName: String(describing: PrefsWindowController.self)) }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        registerDefaults()
        
        // Enable Microsoft AppCenter
        // MSCrashes.setDelegate(self)
        // MSAppCenter.start("", withServices:[MSAnalytics.self, MSCrashes.self])
        
        Constants.getHostname()

        #if SPARKLE
        setupForNonMASBuild()
        #endif

        #if MAS
        setupForMASBuild()
        #endif
        
        showMainWindow(nil)
    }
    
    // Perform any tasks that are specific to non-Mac App Store builds.
    func setupForNonMASBuild() {
        #if SPARKLE
        // I know this is against recommended practice, but I like getting
        // app updates out to customers as quickly as possible. So, I do an update
        // check on every app launch. If you remove this manual check, I think
        // Sparkle will check once a week?
        // SUUpdater.shared()?.checkForUpdatesInBackground()
        #endif
    }

    // Perform any tasks that are specific to Mac App Store builds.
    func setupForMASBuild() {
        #if MAS
        // App Review will reject apps that have anything to do with Sparkle
        // or updating using a mechanism outside the store. (Understandably so.)
        checkForUpdatesMenuItem.isHidden = true
        #endif
    }

    // This is called when our Dock icon is clicked (among other cases).
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showMainWindow(nil)
        return true
    }

    // Populates UserDefaults with the initial default settings for your app.
    // Those values will come from the Defaults.plist in the app bundle.
    func registerDefaults() {
        var defaults: [String: Any] = [:]

        if let defaultsPath = Bundle.main.path(forResource: "Defaults", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: defaultsPath) as? [String: Any] {
                defaults.merge(dict: dict)
            }
        }

        // You can use this opportunity to insert any default values that need
        //  to be computed at runtime and thus can't be stored in Defaults.plist.
        let computedDefaults: [String: Any] = [:]
        defaults.merge(dict: computedDefaults)

        UserDefaults.standard.register(defaults: defaults)
    }

    // If your app receives push notifications or uses CloudKit, they'll arrive here.
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {

    }
}

extension AppDelegate {

    @IBAction func showMainWindow(_ sender: AnyObject?) {
        mainWindowController.showWindow(sender)
    }
    
    @IBAction func showPrefs(_ sender: AnyObject?) {
        prefsWindowController.showWindow(sender)
    }
    
    @IBAction func checkForUpdates(_ sender: AnyObject?) {
        #if SPARKLE
        SUUpdater.shared()?.checkForUpdates(nil)
        #endif
    }
}

// Placeholders to be customized for each app...
extension AppDelegate: NSMenuDelegate, NSMenuItemValidation {

    func menu(_ menu: NSMenu, update item: NSMenuItem, at index: Int, shouldCancel: Bool) -> Bool {
        return true
    }

    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return true
    }
}

extension AppDelegate: MSCrashesDelegate {

    // Give you the opportunity to attach custom data to crash logs before they're sent to AppCenter.
    func attachments(with crashes: MSCrashes, for errorReport: MSErrorReport) -> [MSErrorAttachmentLog] {
        return []
    }
}
