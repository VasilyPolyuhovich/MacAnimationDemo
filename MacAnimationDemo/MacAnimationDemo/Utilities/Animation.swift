//
//  Animation.swift
//  MacAnimationDemo
//
//  Created by Vasyl Polyuhovich on 3/4/19.
//  Copyright © 2019 Vasyl Polyuhovich. All rights reserved.
//

import Cocoa

struct Animation {
    static func opacity(from fromValue: CGFloat, to toValue: CGFloat) -> CABasicAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = fromValue
        opacityAnimation.toValue = toValue
        
        return opacityAnimation
    }

    static func transform(from fromValue: CGFloat = 1.0, to toValue: CGFloat) -> CABasicAnimation {
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(fromValue, fromValue, fromValue))
        transformAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(toValue, toValue, toValue))
        
        return transformAnimation
    }

    static func color(from fromColor: CGColor, to toColor: CGColor) -> CABasicAnimation {
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.fromValue = fromColor
        colorAnimation.toValue = toColor
        colorAnimation.autoreverses = true
        
        return colorAnimation
    }

    static func transform(times: [NSNumber] = [0.0, 0.5, 1.0], values: [CGFloat] = [0.0, 1.4, 1.0], duration: CFTimeInterval = 0.7) -> CAKeyframeAnimation {
        var transformValues = [NSValue]()
        values.forEach {
            transformValues.append(NSValue(caTransform3D: CATransform3DMakeScale($0, $0, 1.0)))
        }
        let transformAnimation = CAKeyframeAnimation(keyPath: "transform")
        transformAnimation.duration = duration
        transformAnimation.values = transformValues
        transformAnimation.keyTimes = times
        transformAnimation.fillMode = .forwards
        transformAnimation.isRemovedOnCompletion = false
        
        return transformAnimation
    }

    static func hide() -> CAKeyframeAnimation {
        let hideAnimation = transform(times: [0.0, 0.3, 1.0], values: [1.0, 1.9, 0.0])
        hideAnimation.duration = 1.2
        return hideAnimation
    }

    static func group(animations: CAAnimation..., duration: CFTimeInterval) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = animations
        animationGroup.duration = duration
        
        return animationGroup
    }
}
