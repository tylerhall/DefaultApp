//
//  Extensions-Shared.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Foundation

extension Double {

    // It's dumb, but I swear I end up having to dump a number into some type
    // of storage that only accepts a String way more often than I care to think about.
    func stringValue() -> String {
        return String(format:"%f", self)
    }
}

extension NSNotification.Name {
    func post(_ object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
}

extension TimeInterval {

    // let foo: TimeInterval = 6227
    // foo.durationString() -> "2h"
    // foo.durationString(2) -> "1h 44m"
    // foo.durationString(3) -> "1h 43m 47s"
    func durationString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        return formatter.string(from: self)!
    }
}

extension Date {
    
    // let d = Date() -> Mar 12, 2020 at 1:51 PM
    // d.stringify() -> "1584039099.486827"
    func stringify() -> String {
        return timeIntervalSince1970.stringValue()
    }

    // Date.unstringify("1584039099.486827") -> Mar 12, 2020 at 1:51 PM
    static func unstringify(_ ts: String) -> Date {
        let dbl = Double(ts) ?? 0
        return Date(timeIntervalSince1970: dbl)
    }
}

extension String {

    // An incredibly lenient and forgiving way to get a numeric String
    // out of another string - typically one provided by the user.
    // You shouldn't rely on this for anythign truly mission critical.
    func numberString() -> String? {
        let strippedStr = trimmingCharacters(in: .whitespacesAndNewlines)
        let isNegative = strippedStr.hasPrefix("-")
        let allowedCharSet = CharacterSet(charactersIn: ".,0123456789")
        let filteredStr = components(separatedBy: allowedCharSet.inverted).joined()
        if (count(of: ".") + count(of: ",")) > 1 { return nil }
        return (isNegative ? "-" : "") + filteredStr
    }

    // Number of times a character occurs within a string.
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }

    // Returns an array of substrings delimited by whitespace - and also
    // combines tokens inside matching quotes into a single token. I don't
    // claim this to be pefect in every edge case - but I haven't encountered
    // a bug yet 🤷‍♀️.
    // "My name is Tim Apple".tokenize() -> ["My", "name", "is", "Tim", "Apple"]
    // "I hope the \"SF Giants\" have a \"better season\" this year" -> ["I", "hope", "the", "SF Giants", "have", "a", "better season", "this", "year"]
    @available(OSX 10.15, iOS 13, *)
    func tokenize() -> [String] {
        enum State {
            case Normal
            case InsideAQuote
        }
        
        let theString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var tokens = [String]()
        var state = State.Normal
        let delimeters = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "\""))
        let quote = CharacterSet(charactersIn: "\"")

        let scanner = Scanner(string: theString)
        scanner.charactersToBeSkipped = .none
        
        while !scanner.isAtEnd {
            if state == .Normal {
                if let token = scanner.scanCharacters(from: delimeters.inverted) {
                    tokens.append(token.trimmingCharacters(in: .whitespacesAndNewlines))
                } else if let delims = scanner.scanCharacters(from: delimeters) {
                    if delims.hasSuffix("\"") {
                        state = .InsideAQuote
                    }
                }
            } else {
                if let token = scanner.scanCharacters(from: quote.inverted) {
                    tokens.append(token.trimmingCharacters(in: .whitespacesAndNewlines))
                    state = .Normal
                }
            }
        }

        return tokens
    }
}

extension Dictionary {

    // Combines self with another dictionary.
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
