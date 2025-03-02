//
//  KCKUIMarco.h
//  KirihaCodeKit
//
//  Created by 御前崎悠羽 on 2024/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kiriha_screenWidth ([UIScreen mainScreen].bounds.size.width)
#define kiriha_screenHeight ([UIScreen mainScreen].bounds.size.height)

/// 设备适配：通用缩放系数，用于计算 W/H。
#define kiriha_scale_commonValue(val) (uiMarkingToDeviceWidthFactor() * (val))
/// 设备适配：宽度适配标注Y轴转换为设备 Y 轴值。
#define kiriha_scale_offYValue(y) (uiMarkingToDeviceYDelta() + uiMarkingToDeviceWidthFactor() * (y))

/// 基准尺寸。以 iPhone 15 Pro Max 为基准。
CGSize kiriha_uiMarkingStandardSize(void);
/// 屏幕旋转之后的宽，长边。
CGFloat kiriha_screenRotateWidth(void);
/// 屏幕旋转之后的高，短边。
CGFloat kiriha_screenRotateHeight(void);
BOOL kiriha_isFullScreenDevice(void);
/// 全面屏适配系数。
CGFloat kiriha_fullScreenScaleRatio(void);
/// UI 标注相对于屏幕宽度的系数。
CGFloat kiriha_uiMarkingToDeviceWidthFactor(void);
/// UI标注相对于屏幕高度的 Padding 值，该值在 PAD 设备上是一个正值，在非 PAD 设备上是一个 0 值，UI 控件的 y 需要加上该偏移。
CGFloat kiriha_uiMarkingToDeviceYDelta(void);

NS_ASSUME_NONNULL_END
