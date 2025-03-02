//
//  KCKUIView.swift
//  KirihaCodeKit
//
//  Created by 御前崎悠羽 on 2021/11/6.
//

import UIKit
import SnapKit

@objcMembers
open class KCKUIView: UIView {
    
    open var enableTouchToCancelAllEditing: Bool = true
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIWindow.kiriha_securyWindow()?.endEditing(self.enableTouchToCancelAllEditing)
    }

}

@objc
public extension UIView {
    
    @objc(KCKViewCornerPosition)
    enum CornerPosition: Int {
        case topLeft = 0
        case topRight = 1
        case bottomLeft = 2
        case bottomRight = 3
        case all = 4
    }
    
    func kiriha_addRoundedCorners(cornerPositons: NSArray, radius: CGFloat) {
        var corners: UInt = CACornerMask().rawValue
        let convertArray: [UIView.CornerPosition] = cornerPositons as! [UIView.CornerPosition]
        for corner in convertArray {
            switch corner {
            case .topLeft:
                corners = corners | CACornerMask.layerMinXMinYCorner.rawValue
            case .topRight:
                corners = corners | CACornerMask.layerMaxXMinYCorner.rawValue
            case .bottomLeft:
                corners = corners | CACornerMask.layerMinXMaxYCorner.rawValue
            case .bottomRight:
                corners = corners | CACornerMask.layerMaxXMaxYCorner.rawValue
            case .all:
                corners = corners | CACornerMask.layerMinXMinYCorner.rawValue | CACornerMask.layerMaxXMinYCorner.rawValue | CACornerMask.layerMinXMaxYCorner.rawValue | CACornerMask.layerMaxXMaxYCorner.rawValue
            }
        }
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = CACornerMask(rawValue: corners)
        } else {
            
        }
    }
    
}

@objc
public extension UIView {

    @objc(KCKViewSeparatorPositon)
    enum SeparatorPositon: Int {
        case top = 0
        case bottom = 1
    }
    
    func kiriha_addSeparator(color: UIColor = UIColor.kiriha_colorWithHexString("#F2F3F7"),
                            position: UIView.SeparatorPositon = .bottom,
                            leftEdge: CGFloat = 0, rightEdge: CGFloat = 0) {
        let aLine: UIView = UIView()
        aLine.backgroundColor = color
        self.addSubview(aLine)
        if position == .top {
            aLine.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(leftEdge)
                make.right.equalToSuperview().offset(-rightEdge)
                make.top.equalToSuperview()
                make.height.equalTo(1)
            }
        } else if position == .bottom {
            aLine.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(leftEdge)
                make.right.equalToSuperview().offset(-rightEdge)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
}
