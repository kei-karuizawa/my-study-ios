//
//  KCKAnimation.swift
//  KirihaCodeKitCodeKit
//
//  Created by 御前崎悠羽 on 2024/8/4.
//

import Foundation

extension UIView {
    
    /**
     利用 `CABasicAnimation` 产生一次简单的动画。动画在完成后默认会使视图停留在动画结束后的位置。
     
     - Parameters:
        - key: 动画标识符。
        - keyPath: 指定哪个属性产生动画。
        - from: 从什么数值开始。
        - to: 从什么数值结束。
        - beginTime: 动画开始时间。
        - duration: 动画持续时间。
        - isRemoveOnCompletion: 是否完成后移除动画。
        - fillMode: 动画模式。
        - completionHandler: 动画完成后的回调。
     */
    @objc
    public func kiriha_addSimpleOnceAnimation(key: String, keyPath: String,
                                              from fromValue: CGFloat, to toValue: CGFloat,
                                              beginTime: CFTimeInterval = 0, duration: CGFloat,
                                              isRemoveOnCompletion: Bool = false,
                                              fillMode: CAMediaTimingFillMode = .forwards,
                                              completionHandler: (() -> Void)?) {
        self.layer.removeAnimation(forKey: key)
        CATransaction.begin()
        let animation: CABasicAnimation = CABasicAnimation()
        animation.keyPath = keyPath
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = CFTimeInterval(duration)
        animation.beginTime = beginTime
        animation.isRemovedOnCompletion = isRemoveOnCompletion
        animation.fillMode = fillMode
        CATransaction.setCompletionBlock {
            completionHandler?()
        }
        self.layer.add(animation, forKey: key)
        CATransaction.commit()
    }
}
