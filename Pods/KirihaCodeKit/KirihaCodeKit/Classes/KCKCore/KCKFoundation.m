//
//  KCKFoundation.m
//  KirihaCodeKit
//
//  Created by 御前崎悠羽 on 2024/8/12.
//

#import <Foundation/Foundation.h>

void kiriha_asyncMainExecuteBlock(void (^block)(void)) {
    if (!block) {
        return;
    }
    // 这里的判断是否在主线程,之前用的 NSThread 的 isMainThread。但是并不是所有在主线程执行的任务,都是主队列的任务，会导致某些需要主队列运行的库产生问题 .VectorKit。
    // dispatch_queue_get_label 返回创建队列时为队列指定的标签。主队列标签为: com.apple.main-thread。
    // 如果在主线程内调用 dispatch_async(dispatch_get_main_queue(), block)，可能会导致 block 在下一次 runloop 执行，从而导致更新 UI 时出错，而且还浪费资源。
    // 所以如果在主线成，直接执行了。不在才回归。
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
    //    if ([NSThread isMainThread]) {
    //        block();
    //    } else {
    //        dispatch_async(dispatch_get_main_queue(), block);
    //    }
}

__attribute__((overloadable)) void kiriha_asyncMainBlock(double second, void (^block)(void)) {
    if (!block) {
        return;
    }
    if (second > 0) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

inline BOOL kiriha_isEmptyString(NSString *string) {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    NSString *trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimString.length == 0) {
        return YES;
    }
    NSString *lowercaseString = trimString.lowercaseString;
    if ([lowercaseString isEqualToString:@"(null)"] || [lowercaseString isEqualToString:@"null"] || [lowercaseString isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

inline BOOL kiriha_isNotEmptyString(NSString *string) {
    return !kiriha_isEmptyString(string);
}

inline BOOL kiriha_isBlankString(NSString *string) {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    NSString *trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimString.length == 0) {
        return YES;
    }
    return NO;
}

inline BOOL kiriha_isNotBlankString(NSString *string) {
    return !kiriha_isBlankString(string);
}
