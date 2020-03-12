//
//  Extensions.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

extension NSView {
    func pinEdges(to other: NSView, offset: CGFloat = 0, animate: Bool = false) {
        if animate {
            animator().leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: offset).isActive = true
        } else {
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: offset).isActive = true
            trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: other.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
        }
    }
}

extension NSTableView {
    func reloadOnMainThread(_ complete: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.reloadData()
            complete?()
        }
    }

    func reloadMaintainingSelection(_ complete: (() -> ())? = nil) {
        let oldSelectedRowIndexes = selectedRowIndexes
        reloadOnMainThread {
            if oldSelectedRowIndexes.count == 0 {
                if self.numberOfRows > 0 {
                    self.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
                }
            } else {
                self.selectRowIndexes(oldSelectedRowIndexes, byExtendingSelection: false)
            }
        }
    }

    func selectFirstPossibleRow() {
        for i in 0..<numberOfRows {
            if let delegate = delegate, let shouldSelect = delegate.tableView?(self, shouldSelectRow: i) {
                if shouldSelect {
                    selectRowIndexes(IndexSet(integer: i), byExtendingSelection: false)
                    return
                }
            } else {
                selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
            }
        }
    }

    func selectLastPossibleRow() {
        for i in stride(from: numberOfRows - 1, to: 0, by: -1) {
            if let delegate = delegate, let shouldSelect = delegate.tableView?(self, shouldSelectRow: i) {
                if shouldSelect {
                    selectRowIndexes(IndexSet(integer: i), byExtendingSelection: false)
                    return
                }
            } else {
                selectRowIndexes(IndexSet(integer: numberOfRows - 1), byExtendingSelection: false)
            }
        }
    }
}

extension String {

    // I should really just stop using these and switch to one of the better, full-featured attributed string
    // libraries, but meh. This stuff works for now.
    func boldString(textColor: NSColor = NSColor.textColor) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: self)
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSRange(self.startIndex..., in: self))
        attrStr.addAttribute(NSAttributedString.Key.font, value: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize), range: NSRange(self.startIndex..., in: self))
        return attrStr
    }

    func coloredAttributedString(textColor: NSColor = NSColor.textColor) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string: self)
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSRange(self.startIndex..., in: self))
        attrStr.addAttribute(NSAttributedString.Key.font, value: NSFont.systemFont(ofSize: NSFont.systemFontSize), range: NSRange(self.startIndex..., in: self))
        return attrStr
    }
}

extension NSImage {

    func writeJPGToURL(_ url: URL, quality: Float = 0.7) -> Bool {
        let properties = [NSBitmapImageRep.PropertyKey.compressionFactor: quality]
        guard let imageData = self.tiffRepresentation else { return false }
        guard let imageRep = NSBitmapImageRep(data: imageData) else { return false }
        guard let fileData = imageRep.representation(using: .jpeg, properties: properties) else { return false }

        do {
            try fileData.write(to: url)
        } catch {
            return false
        }

        return true
    }
    
    func writePNGToURL(_ url: URL) -> Bool {
        guard let imageData = self.tiffRepresentation else { return false }
        guard let imageRep = NSBitmapImageRep(data: imageData) else { return false }
        guard let fileData = imageRep.representation(using: .png, properties: [:]) else { return false }

        do {
            try fileData.write(to: url)
        } catch {
            return false
        }

        return true
    }

    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()

        return image
    }
}

extension NSOutlineView {
    
    var selectedItem: OutlineItem? {
        get {
            if selectedRow == -1 {
                return nil
            }

            if let item = item(atRow: selectedRow) as? OutlineItem {
                return item
            }
            
            return nil
        }
    }

    var selectedView: NSTableCellView? {
        get {
            if selectedRow > -1 {
                return view(atColumn: 0, row: self.selectedRow, makeIfNecessary: false) as? NSTableCellView
            } else {
                return nil
            }
        }
    }

    func expandAll() {
        DispatchQueue.main.async {
            self.expandItem(nil, expandChildren: true)
        }
    }
}
