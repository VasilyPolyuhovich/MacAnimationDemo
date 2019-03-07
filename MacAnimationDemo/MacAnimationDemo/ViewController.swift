//
//  ViewController.swift
//  MacAnimationDemo
//
//  Created by Vasyl Polyuhovich on 3/4/19.
//  Copyright © 2019 Vasyl Polyuhovich. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    @IBOutlet weak var animatedView: WavesView!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.delegate = self
        animatedView.paddingBetweenCircles = 50
    }
    
    func windowDidResize(_ notification: Notification) {
        if let newSize = view.window?.frame.size {
            if newSize.height > view.frame.width {
                let count = (newSize.height / animatedView.paddingBetweenCircles + 1).rounded()
                animatedView.numberOfCircles = Int(count)
            } else {
                let count = (newSize.width / animatedView.paddingBetweenCircles + 1).rounded()
                animatedView.numberOfCircles = Int(count)
            }
        }
    }
}

