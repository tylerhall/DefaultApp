//
//  SidebarOutlineView.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import AppKit

// This NSOutlineView subclass coordinates with the RootItem and OutlineItem
// classes to (easily?) populate the tree.
class SidebarOutlinewView: NSOutlineView {
    
    static var shared: SidebarOutlinewView?

    var rootItem = RootItem()
    var draggedItem: OutlineItem?
    var isReloading = false

    let serialQueue = DispatchQueue(label: "SidebarOutlinewView Serial Queue")

    override func awakeFromNib() {
        SidebarOutlinewView.shared = self

        // Regsiter your own custom cells here...
        register(NSNib(nibNamed: String(describing: SidebarTableCellView.self), bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(String(describing: SidebarTableCellView.self)))
        
        delegate = self
        dataSource = self
    }
    
    @objc func reloadViaNotification(_ notification: Notification) {
        reloadData()
    }

    override func reloadData() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.rootItem.reloadData {
                DispatchQueue.main.async {
                    self.isReloading = true

                    let previousSelectedRowIndexes = self.selectedRowIndexes
                    
                    super.reloadData()
                    
                    self.expandItem(nil, expandChildren: true)
                    self.selectRowIndexes(previousSelectedRowIndexes, byExtendingSelection: false)
                    
                    if self.selectedRow == -1 {
                        self.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
                    }

                    self.isReloading = false
                }
            }
        }
    }

    override func expandItem(_ item: Any?, expandChildren: Bool) {
        super.expandItem(item, expandChildren: expandChildren)
        if let item = item as? OutlineItem {
            item.setExpanded?()
        }
    }
    
    override func collapseItem(_ item: Any?, collapseChildren: Bool) {
        super.collapseItem(item, collapseChildren: collapseChildren)
        if let item = item as? OutlineItem {
            item.setCollapsed?()
        }
    }
    
    // Hide the disclosure triangle when the item is not expandable.
    override func frameOfOutlineCell(atRow row: Int) -> NSRect {
        if let item = item(atRow: row) as? OutlineItem {
            if item.isExpandable {
                let rect = super.frameOfOutlineCell(atRow: row)
                return rect.offsetBy(dx: 0, dy: 4)
            } else {
                return .zero
            }
        }
        
        return .zero
    }
}

extension SidebarOutlinewView: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        let outlineItem = item as! OutlineItem
        return outlineItem.isSelectable
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
        if isReloading, let item = item as? OutlineItem {
            return item.isExpanded?() ?? true
        }
        return true
    }

    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return SidebarTableViewRow(frame: .zero)
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let outlineItem = item as! OutlineItem

        if outlineItem.cellType == RootItem.CellType.Default {
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SidebarTableCellView"), owner: nil) as! SidebarTableCellView
            view.imageView?.image = outlineItem.image
            view.textField?.stringValue = outlineItem.title
            view.textField?.font = NSFont.systemFont(ofSize: (view.textField?.font?.pointSize)!)
            return view
        }

        return nil
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        Constants.sidebarSelectionDidChangeNotification.post()
    }
}

extension SidebarOutlinewView: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return rootItem.children[index]
        } else {
            let outlineItem = item as! OutlineItem
            return outlineItem.children[index]
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let outlineItem = item as! OutlineItem
        return outlineItem.isExpandable
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return rootItem.children.count
        } else {
            let outlineItem = item as! OutlineItem
            return outlineItem.children.count
        }
    }

    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if let outlineItem = item as? OutlineItem {
            return outlineItem.value
        }

        return nil
    }
}
