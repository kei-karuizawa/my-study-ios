//
//  KCKUIMarco.swift
//  KirihaCodeKit
//
//  Created by 御前崎悠羽 on 2024/8/12.
//

import Foundation

/// 设备适配：宽度适配宽度缩放系数。
public func kiriha_scale_width() -> CGFloat {
    return kiriha_uiMarkingToDeviceWidthFactor()
}

/// 设备适配：宽度适配标注Y轴转换为设备 Y 轴值。
public func kiriha_scale_offYValue(_ y: CGFloat) -> CGFloat {
    return (kiriha_uiMarkingToDeviceYDelta() + kiriha_uiMarkingToDeviceWidthFactor() * (y));
}

/// 设备适配：通用缩放系数，用于计算 W/H。
public func kiriha_scale_commonValue(_ val: CGFloat) -> CGFloat {
    return (kiriha_uiMarkingToDeviceWidthFactor() * (val));
}

// 横竖屏设备全屏宽。
public func kiriha_screen_rotate_width() -> CGFloat {
    kiriha_screenRotateWidth()
}

//横竖屏设备全屏高。
public func kiriha_screen_rotate_height() -> CGFloat {
    kiriha_screenRotateHeight()
}

// 设备全屏宽。
public func kiriha_screenWidth() -> CGFloat {
    UIScreen.main.bounds.width
}
// 设备全屏高。
public func kiriha_screenHeight() -> CGFloat {
    UIScreen.main.bounds.height
}

