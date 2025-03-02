//
//  KCKUIMarco.m
//  KirihaCodeKit
//
//  Created by 御前崎悠羽 on 2024/8/12.
//

#import "KCKUIMarco.h"

/// 基准尺寸。以 iPhone 15 Pro Max 为基准。
CGSize kiriha_uiMarkingStandardSize(void) {
    static CGSize uiMarkingStandardSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uiMarkingStandardSize = CGSizeMake(645, 1398);
    });
    return uiMarkingStandardSize;
}

/// 屏幕旋转之后的宽，长边。
CGFloat kiriha_screenRotateWidth(void) {
    static CGFloat screenRotateWidth = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
        screenRotateWidth = MAX(screenW, screenH);
        NSLog(@"screenRotateWidth = %.2f", screenRotateWidth);
    });
    return screenRotateWidth;
}

/// 屏幕旋转之后的高，短边。
CGFloat kiriha_screenRotateHeight(void) {
    static CGFloat screenRotateHeight = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
        screenRotateHeight = MIN(screenW, screenH);
        NSLog(@"screenRotateHeight = %.2f", screenRotateHeight);
    });
    return screenRotateHeight;
}

BOOL kiriha_isFullScreenDevice(void) {
    static BOOL isFullScreenDevice = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenW = kiriha_screenRotateWidth();
        CGFloat screenH = kiriha_screenRotateHeight();
        isFullScreenDevice = (screenW / screenH) > 2;
    });
    return isFullScreenDevice;
}

/// 全面屏适配系数。
CGFloat kiriha_fullScreenScaleRatio(void) {
    static CGFloat ratio = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize standardSize = kiriha_uiMarkingStandardSize();
        CGFloat screenW = kiriha_screenRotateWidth();
        CGFloat screenH = kiriha_screenRotateHeight();
        CGFloat screenStandardW = screenH * (standardSize.width / standardSize.height);
        ratio = screenStandardW / screenW;
        /// eg. iPhone 12 844*390
        /// screenStandardW = 390 * (1920 / 1080) = 693.3
        /// ratio = 693.3 / 844 = 0.82
        NSLog(@"ratio = %.2f", ratio);
        
    });
    return ratio;
}

/// UI 标注相对于屏幕宽度的系数。
CGFloat kiriha_uiMarkingToDeviceWidthFactor(void) {
    static CGFloat uiMarkingToDeviceWidthFactor = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize standardSize = kiriha_uiMarkingStandardSize();
        if (kiriha_isFullScreenDevice()) {
            /// eg. iPhone 12 844*390
            /// uiMarkingToDeviceWidthFactor = 0.82 * 844 / 1920 = 0.36
            uiMarkingToDeviceWidthFactor = kiriha_fullScreenScaleRatio() * kiriha_screenRotateWidth() / standardSize.width;
        } else {
            /// eg. iPad Mini 5  1024*768
            /// uiMarkingToDeviceWidthFactor = 1024 / 1920 = 0.53
            uiMarkingToDeviceWidthFactor = kiriha_screenRotateWidth() / standardSize.width;
        }
        NSLog(@"uiMarkingToDeviceWidthFactor = %.2f", uiMarkingToDeviceWidthFactor);
    });
    return uiMarkingToDeviceWidthFactor;
}

/// UI标注相对于屏幕高度的 Padding 值，该值在 PAD 设备上是一个正值，在非 PAD 设备上是一个 0 值，UI 控件的 y 需要加上该偏移。
CGFloat kiriha_uiMarkingToDeviceYDelta(void) {
    static CGFloat uiMarkingToDeviceYDelta = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize standardSize = kiriha_uiMarkingStandardSize();
        CGFloat screenW = kiriha_screenRotateWidth();
        CGFloat screenH = kiriha_screenRotateHeight();
        CGFloat screenStandardH = screenW * (standardSize.height / standardSize.width);
        uiMarkingToDeviceYDelta = MAX(0, (screenH - screenStandardH) / 2);
        NSLog(@"uiMarkingToDeviceYDelta = %.2f", uiMarkingToDeviceYDelta);
    });
    return uiMarkingToDeviceYDelta;
}
