//
//  WavesView.swift
//  MacAnimationDemo
//
//  Created by Vasyl Polyuhovich on 3/4/19.
//  Copyright © 2019 Vasyl Polyuhovich. All rights reserved.
//

import Cocoa

protocol WavesViewDataSource: class {
    func wavesView(wavesView: WavesView, viewFor item: Item, preferredSize: CGSize) -> NSView
}

final class WavesView: PulseView {
    var wavesCapacity: Int {
        if allPossiblePositions.isEmpty {
            findPossiblePositions()
        }
        return allPossiblePositions.count
    }

    var paddingBetweenItems: CGFloat = 10 {
        didSet {
            redrawItems()
        }
    }

    override var bounds: CGRect {
        didSet {
            minimumCircleRadius = 15
            redrawItems()
        }
    }
    
    override var frame: CGRect {
        didSet {
            minimumCircleRadius = 15
            redrawItems()
        }
    }

    weak var dataSource: WavesViewDataSource?
    var itemBackgroundColor = NSColor.turquoise
    
    private var allPossiblePositions = [CGPoint]()
    private var availablePositions = [CGPoint]()
    private var itemsViews = [ItemView]()
    private var viewToRemove: NSView?

    private var itemRadius: CGFloat {
        return paddingBetweenCircles / 3
    }
    
    // MARK: View Life Cycle
    
    override func setup() {
        paddingBetweenCircles = 10
        minimumCircleRadius = 15
        
        super.setup()
    }
    
    override func redrawCircles() {
        super.redrawCircles()
        
        redrawItems()
    }
    
    private func redrawItems() {
        let items = itemsViews
        allPossiblePositions.removeAll()
        availablePositions.removeAll()
        itemsViews.removeAll()
        
        findPossiblePositions()
        availablePositions = allPossiblePositions
        
        items.forEach {
            let view = $0.view
            view.layer?.removeAllAnimations()
            view.removeFromSuperview()
            var index = $0.index
            add(item: $0.item, at: &index, using: nil)
        }
    }
    
    // MARK: Utilities

    private func findPossiblePositions() {
        for (index, layer) in circlesLayer.enumerated() {
            let origin = layer.position
            let radius = radiusOfCircle(at: index)
            let circle = Circle(origin: origin, radius:radius)
            
            // calculate the capacity using: (2π * r1 / 2 * r2) ; r2 = (itemRadius + padding/2)
            let capicity = (radius * CGFloat.pi) / (itemRadius + paddingBetweenItems/2)

            for index in 0 ..< Int(capicity) {
                let angle = ((CGFloat(index) * 2 * CGFloat.pi) / CGFloat(capicity))/* + randomAngle */
                let itemOrigin = circle.point(in: angle)
                allPossiblePositions.append(itemOrigin)
            }
        }
    }

    private func add(item: Item, at index: inout Int, using animation: CAAnimation? = Animation.transform()) {
        if allPossiblePositions.isEmpty {
            findPossiblePositions()
        }
        if availablePositions.count == 0 {
            print("Warning: you use more than the capacity of the waves view, some layers will overlaying other layers")
            availablePositions = allPossiblePositions
        }

        if index >= availablePositions.count {
            index = Int(arc4random_uniform(UInt32(availablePositions.count)))
        }
        let origin = availablePositions[index]
        availablePositions.remove(at: index)
        
        let preferredSize = CGSize(width: itemRadius*2, height: itemRadius*2)
        let customView = dataSource?.wavesView(wavesView: self, viewFor: item, preferredSize: preferredSize)
        let itemView = addItem(view: customView, with: origin, and: animation)
        let itemLayer = ItemView(view: itemView, item: item, index: index)
        self.addSubview(itemView)
        itemsViews.append(itemLayer)
    }
    
    private func addItem(view: NSView?, with origin: CGPoint, and animation: CAAnimation?) -> NSView {
        let itemView = view ?? NSView(frame: NSRect.zero)
        
        guard let anim = animation else { return itemView }
        let hide = Animation.transform(to: 0.0)
        hide.duration = anim.beginTime - CACurrentMediaTime()
        itemView.layer?.add(hide, forKey: nil)
        itemView.layer?.add(anim, forKey: nil)
        
        return itemView
    }

    private func removeWithAnimation(view: NSView) {
        viewToRemove = view
        let hideAnimation = Animation.hide()
        hideAnimation.delegate = self
        
        view.layer?.add(hideAnimation, forKey: nil)
    }
}

extension WavesView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        viewToRemove?.removeFromSuperview()
        viewToRemove = nil
    }
}

// MARK: public methods
extension WavesView {
    func add(items: [Item], using animation: CAAnimation = Animation.transform()) {
        for index in 0 ..< items.count {
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(animation.duration/2 * Double(index))
            self.add(item: items[index], using: animation)
        }
    }
    
    func add(item: Item, using animation: CAAnimation = Animation.transform()) {
        if allPossiblePositions.isEmpty {
            findPossiblePositions()
        }
        
        let count = availablePositions.count == 0 ? allPossiblePositions.count : availablePositions.count
        var randomIndex = Int(arc4random_uniform(UInt32(count)))
        add(item: item, at: &randomIndex, using: animation)
    }

    func remove(item: Item) {
        guard let index = itemsViews.index(where: { $0.item.uniqueKey == item.uniqueKey }) else {
            print("\(String(describing: item.uniqueKey)) not found")
            return
        }
        let item = itemsViews[index]
        removeWithAnimation(view: item.view)
        itemsViews.remove(at: index)
    }

    func view(for item: Item) -> NSView? {
        guard let index = itemsViews.index(where: { $0.item === item }) else { return nil }
        return itemsViews[index].view
    }
}
