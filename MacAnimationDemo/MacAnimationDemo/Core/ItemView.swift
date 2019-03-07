//
//  ItemLayer.swift
//  MacAnimationDemo
//
//  Created by Vasyl Polyuhovich on 3/4/19.
//  Copyright © 2019 Vasyl Polyuhovich. All rights reserved.
//

import Cocoa

class ItemView {
    let view: NSView
    let item: Item
    var index: Int
    
    init(view: NSView, item: Item, index: Int) {
        self.view = view
        self.item = item
        self.index = index
    }
}
