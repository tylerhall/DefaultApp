//
//  RootItem.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Foundation

// RootItem and OutlineItem are some of my oldest code - dating back to 2006/2007
// before I converted them to Swift recently. I have no idea if there are better
// ways of handling NSOutlineView logic nowadays, but when I googled all this stuff
// years and years ago, there wasn't much out there. This is what I eventually landed
// on myself and have mostly stuck with through the years.

// RootItem is the, uh, root item that you give to your NSOutlineView to display your data.
// I typically use this in my app's sidebar and source lists.
//
// The class below has been popualted with fake data as if we were bulding an example git
// client app that has a sidebar like this...
//
// - Working Copy
// - History
// - Stashes
// - Branches
// - - feature/add-syncing
// - - feature/implement-new-api
// - - bugfix/crash-123
// - Tags
// - - v123
// - - v124
//
//

class RootItem {
    
    enum CellType: String {
        case Default
        case TextAndImage
        case Branch
        case Tag
    }

    var serialQueue = DispatchQueue(label: "RootItem Serial Queue")

    var children = [OutlineItem]()
    var sortedChildren: [OutlineItem] {
        get {
            return children.sorted(by: { (a, b) -> Bool in
                return a.sortOrder < b.sortOrder
            })
        }
    }

    lazy var workingCopyItem: OutlineItem  = {
            let item = OutlineItem()
            item.cellType = CellType.TextAndImage
            item.title = "Working Copy"
            item.isExpandable = false
            item.isSelectable = true
            item.sortOrder = 0
            return item
    }()

    lazy var historyItem: OutlineItem  = {
            let item = OutlineItem()
            item.cellType = CellType.TextAndImage
            item.title = "History"
            item.isExpandable = false
            item.isSelectable = true
            item.sortOrder = 1
            return item
    }()
    
    lazy var branchesItem: OutlineItem  = {
            let item = OutlineItem()
            item.cellType = CellType.TextAndImage
            item.title = "Branches"
            item.isExpandable = true
            item.isSelectable = false
            item.sortOrder = 2
            return item
    }()

    lazy var tagsItem: OutlineItem  = {
            let item = OutlineItem()
            item.cellType = CellType.TextAndImage
            item.title = "Tags"
            item.isExpandable = true
            item.isSelectable = false
            item.sortOrder = 3
            return item
    }()

    init() {
        children.append(workingCopyItem)
        children.append(historyItem)
        children.append(branchesItem)
        children.append(tagsItem)
    }

    // Reloads RootItem's data.
    // Note: reloadData() is mutually exclusive from
    // when/where your calls reloadData() on your NSOutlineView.
    // However, typically, NSOutlineView.reloadData() will often
    // be run inside the completed() callback after the data
    // is reloaded.
    func reloadData(_ completed: (() -> ())? = nil) {
        serialQueue.sync {
            // Do your data reloading logic...
            //
            // Create children OutlineItems and populate
            // them into workingCopyItem, historyItem,
            // branchesItem, and tagsItem as appropriate.
        }
        completed?()
    }
}
