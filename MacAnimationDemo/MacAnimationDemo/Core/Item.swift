//
//  Item.swift
//  MacAnimationDemo
//
//  Created by Vasyl Polyuhovich on 3/4/19.
//  Copyright © 2019 Vasyl Polyuhovich. All rights reserved.
//

import Cocoa

class Item {
    let uniqueKey: String
    let value: Any

    init(uniqueKey: String, value: Any) {
        self.uniqueKey = uniqueKey
        self.value = value
    }
}
