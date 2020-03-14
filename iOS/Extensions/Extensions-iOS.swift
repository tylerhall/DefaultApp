//
//  Extensions-iOS.swift
//  DefaultApp-iOS
//
//  Created by Tyler Hall on 3/14/20.
//  Copyright © 2020 Your Company. All rights reserved.
//

import UIKit

extension UIView {
    func pinEdges(to other: UIView, offset: CGFloat = 0, animate: Bool = false) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: offset).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}

