//
//  OutlineItem.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

// OutlineItem and RootItem are some of my oldest code - dating back to 2006/2007
// before I converted them to Swift recently. I have no idea if there are better
// ways of handling NSOutlineView logic nowadays, but when I googled all this stuff
// years and years ago, there wasn't much out there. This is what I eventually landed
// on myself and have mostly stuck with through the years.

// A generic object that represents a node in a tree structure - to be used with NSOutlineView.
class OutlineItem {

    var id = ""
    var cellType: RootItem.CellType = .Default
    var title = ""
    var subtitle: String?
    var isExpandable = false
    var isSelectable = false
    var sortOrder = Int.max // Defaults to a large value so new nodes automaticall sort to the bottom
    var image: NSImage?
    var uuid: String = ""

    var parent: OutlineItem?

    var userInfo: Any? // Any custom data you want to attach

    // These callbacks will be executed when a NSOutlineView item's expansion state changes.
    var setExpanded: (() -> ())?
    var setCollapsed: (() -> ())?

    // Gives you the opportunity to dynamically decide if the item should be expanded or not.
    var isExpanded: (() -> (Bool))?

    var children = [OutlineItem]()
    
    // Sorts the children by sortOrder before falling back on a dumb
    // string .compare() for ties.
    var sortedChildren: [OutlineItem] {
        get {
            return children.sorted(by: { (a, b) -> Bool in
                if a.sortOrder == b.sortOrder {
                    return a.title.lowercased().compare(b.title.lowercased()) == .orderedAscending
                } else {
                    return a.sortOrder < b.sortOrder
                }
            })
        }
    }

    var count: Int {
        get {
            return children.count
        }
    }

    var isLeaf: Bool {
        get {
            return children.count == 0
        }
    }

    var value: AnyObject?

    // Returns a one-deimensional array containing all
    // of the item's children as their descendents.
    func allChildren() -> [OutlineItem] {
        var kids = [OutlineItem]()
        for item in children {
            kids.append(item)
            let theirKids = item.allChildren()
            kids.append(contentsOf: theirKids)
        }
        return kids
    }

    // This is just a helper function you can call that will
    // assign boilerplate logic for the expansion callback
    // functions if you don't have your own custom logic to
    // perform.
    func setDefaultExpansionBehavior() {
        isExpanded = {
            let defaults = Constants.userDefaultsExpansion
            if let isExpanded = defaults?.bool(forKey: self.id) {
                return isExpanded
            }
            return defaults?.bool(forKey: Constants.userDefaultsSidebarExpandByDefault) ?? false
        }
        setExpanded = {
            let defaults = Constants.userDefaultsExpansion
            defaults?.set(true, forKey: self.id)
        }
        setCollapsed = {
            let defaults = Constants.userDefaultsExpansion
            defaults?.set(false, forKey: self.id)
        }
    }
}
