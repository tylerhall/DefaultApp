//
//  Constants.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#endif

class Constants {

    // The name of the user's Mac/iDevice. I occasionally have a use for this - especially
    // when I'm writing any sort of cross-device sync code. The .current() call executes
    // synchronously and can block a thread, so that's why it's sent to the background.
    static var hostname: String?
    static func getHostname(_ completion: ((String?) -> ())?  = nil) {
        DispatchQueue.global(qos: .background).async {
            #if os(macOS)
            Constants.hostname = Host.current().localizedName
            #else
            Constants.hostname = UIDevice.current.name
            #endif
            completion?(Constants.hostname)
        }
    }

    // My NSOutlineViews typically remember the expansion states of various
    // nodes by saving their settings into a custom UserDefaults suite.
    // To see where these are used, look in: macOS/UI/Sidebar/*.swift
    static let userDefaultsSidebarExpansionDomain = "\(Constants.bundleID).SidebarExpansion"
    static let userDefaultsExpansion = UserDefaults.init(suiteName: Constants.userDefaultsSidebarExpansionDomain)
    static let userDefaultsSidebarExpandByDefault = "userDefaultsSidebarExpandByDefault"

    // Sidebar notifications...
    static let sidebarShouldReloadNotification = NSNotification.Name(rawValue: "sidebarShouldReloadNotification")
    static let sidebarSelectionDidChangeNotification = NSNotification.Name(rawValue: "sidebarSelectionDidChangeNotification")
    static let sidebarSortOrderDidChangeNotification = NSNotification.Name(rawValue: "sidebarSortOrderDidChangeNotification")

    static var bundleID: String {
        if let bundleID = Bundle.main.bundleIdentifier {
            return bundleID
        }
        fatalError()
    }

    // I append baseName onto various filenames and/or directories so I can easily
    // keep separate settings / databases / support files between my dev and production builds.
    static var baseName: String {
        #if DEBUG
            return "Dev"
        #else
            return "Prod"
        #endif
    }

    static var appSupportDirectoryURL: URL {
        guard let appSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent(Constants.bundleID) else {
            fatalError()
        }

        if !FileManager.default.fileExists(atPath: appSupportDirectoryURL.path) {
            try! FileManager.default.createDirectory(at: appSupportDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }

        return appSupportDirectoryURL
    }

    static var cacheDirectoryURL: URL {
        guard let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(Constants.bundleID) else {
            fatalError()
        }

        if !FileManager.default.fileExists(atPath: cacheDirectoryURL.path) {
            try! FileManager.default.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }

        return cacheDirectoryURL
    }
}
