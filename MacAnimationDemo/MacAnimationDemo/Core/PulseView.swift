//
//  PulseView.swift
//  MacAnimationDemo
//
//  Created by Vasyl Polyuhovich on 3/4/19.
//  Copyright © 2019 Vasyl Polyuhovich. All rights reserved.
//

import Cocoa

class PulseView: NSView {
    private var circleAnimationDuration: CFTimeInterval {
        if circlesLayer.count ==  0 {
            return CFTimeInterval(animationDuration)
        }
        return CFTimeInterval(animationDuration) / CFTimeInterval(circlesLayer.count)
    }
    
    private var circlesAnimationTimer: Timer?
    
    var maxCircleRadius: CGFloat {
        if numberOfCircles == 0 {
            return min(bounds.midX, bounds.midY)
        }
        return (circlesPadding * CGFloat(numberOfCircles - 1) + minimumCircleRadius)
    }
    
    var circlesLayer = [CAShapeLayer]()

    var circlesPadding: CGFloat {
        if paddingBetweenCircles != -1 {
            return paddingBetweenCircles
        }
        let availableRadius = min(bounds.width, bounds.height)/2 - (minimumCircleRadius)
        return  availableRadius / CGFloat(numberOfCircles)
    }

    var numberOfCircles: Int = 3 {
        didSet {
            redrawCircles()
        }
    }

    var paddingBetweenCircles: CGFloat = -1 {
        didSet {
            redrawCircles()
        }
    }

    var circleOffColor: NSColor = .pulsePink {
        didSet {
            circlesLayer.forEach {
                $0.strokeColor = circleOffColor.cgColor
            }
        }
    }

    var circleOnColor: NSColor = .white

    var minimumCircleRadius: CGFloat = 10 {
        didSet {
            if minimumCircleRadius < 5 {
                minimumCircleRadius = 5
            }
            redrawCircles()
        }
    }
    
    var animationDuration: CGFloat = 0.9 {
        didSet {
            stopAnimation()
            startAnimation()
        }
    }

    override var bounds: CGRect {
        didSet {
            // the sublyers are based in the view size, so if the view change the size, we should redraw sublyers
            redrawCircles()
        }
    }
    
    // MARK: init methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        drawSublayers()
        animateSublayers()
    }
    
    // MARK: Drawing

    private func drawCircle(with index: Int) {
        let radius = radiusOfCircle(at: index)
        if radius > maxCircleRadius { return }
        
        let circleLayer = Drawer.circleLayer(radius: radius, origin: bounds.center, color: circleOffColor.cgColor)
        circleLayer.lineWidth = 2.0
        circlesLayer.append(circleLayer)
        self.layer?.addSublayer(circleLayer)
    }
    
    private func drawSublayers() {
        redrawCircles()
    }
    
    func radiusOfCircle(at index: Int) -> CGFloat {
        return (circlesPadding * CGFloat(index)) + minimumCircleRadius
    }

    override func layout() {
        super.layout()
        
        circlesLayer.forEach {
            $0.position = bounds.center
        }
    }

    func redrawCircles() {
        circlesLayer.forEach {
            $0.removeFromSuperlayer()
        }
        circlesLayer.removeAll()
        for i in 0 ..< numberOfCircles {
            drawCircle(with: i)
        }
    }

    // MARK: Animation
    
    private func animateSublayers() {
        animateCircles()
        startAnimation()
    }
    
    @objc private func animateCircles() {
        for index in 0 ..< circlesLayer.count {
            let transformAnimation = Animation.transform(from: circlesLayer[index].lineWidth, to: circlesLayer[index].lineWidth + 0.2)
            transformAnimation.duration = circleAnimationDuration
            //transformAnimation.autoreverses = true
            transformAnimation.beginTime = CACurrentMediaTime() + CFTimeInterval(circleAnimationDuration * Double(index))
            circlesLayer[index].add(transformAnimation, forKey: "wave")
            
        }
    }
}

extension PulseView {
    func startAnimation() {
        layer?.removeAllAnimations()
        circlesAnimationTimer?.invalidate()
        let timeInterval = CFTimeInterval(animationDuration) + circleAnimationDuration
        circlesAnimationTimer =  Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(animateCircles), userInfo: nil, repeats: true)
    }
    
    func stopAnimation() {
        layer?.removeAllAnimations()
        circlesAnimationTimer?.invalidate()
    }
}
