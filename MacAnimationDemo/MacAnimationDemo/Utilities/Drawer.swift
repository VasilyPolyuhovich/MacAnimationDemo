
//  Drawer.swift
//  MacAnimationDemo
//
//  Created by Vasyl Polyuhovich on 3/4/19.
//  Copyright © 2019 Vasyl Polyuhovich. All rights reserved.
//

import Cocoa

struct Circle {
    var origin = CGPoint.zero
    var radius: CGFloat = 0
    
    init(origin: CGPoint, radius: CGFloat) {
        assert(radius >= 0, NSLocalizedString("radius value is wrong", comment: ""))
        
        self.origin = origin
        self.radius = radius
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

struct Drawer {
    private static func layer(radius: CGFloat, origin: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        layer.position = origin
        
        let center = CGPoint(x: radius, y: radius)
        let path = NSBezierPath()
        path.appendArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        path.close()
        layer.path = path.quartzPath
        
        return layer
    }

    static func circleLayer(radius: CGFloat, origin: CGPoint, color: CGColor) -> CAShapeLayer {
        let circleLayer = self.layer(radius: radius, origin: origin)
        circleLayer.fillColor = NSColor.clear.cgColor
        circleLayer.strokeColor = color
        circleLayer.lineWidth = 1.0
        
        return circleLayer
    }
}

extension Circle {
    func point(in angle: CGFloat) -> CGPoint {
        let x = self.radius * cos(angle) + self.origin.x // cos(α) = x / radius
        let y = self.radius * sin(angle) + self.origin.y // sin(α) = y / radius
        let point = CGPoint(x: x, y: y)
        
        return point
    }
}

extension NSBezierPath {
    
    var quartzPath: CGPath {
        
        get {
            return self.transformToCGPath()
        }
    }
    
    // Transforms the NSBezierPath into a CGPathRef

    private func transformToCGPath() -> CGPath {
        
        // Create path
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        let numElements = self.elementCount
        
        if numElements > 0 {
            for index in 0..<numElements {
                
                let pathType = self.element(at: index, associatedPoints: points)
                
                switch pathType {
                    
                case .moveTo:
                    path.move(to: points[0])
                case .lineTo:
                    path.addLine(to: points[0])
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePath:
                    path.closeSubpath()
                }
            }
        }
        points.deallocate()
        return path
    }
}
