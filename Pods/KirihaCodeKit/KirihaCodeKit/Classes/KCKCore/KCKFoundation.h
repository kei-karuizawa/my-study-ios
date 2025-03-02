//
//  KCKFoundation.h
//  Pods
//
//  Created by 御前崎悠羽 on 2024/8/12.
//

#import <Foundation/Foundation.h>

#ifndef KCKFoundation_h
#define KCKFoundation_h

#ifndef kiriha_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define kiriha_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define kiriha_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define kiriha_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define kiriha_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef kiriha_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define kiriha_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define kiriha_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define kiriha_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define kiriha_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

FOUNDATION_EXTERN void kiriha_asyncMainExecuteBlock(void (^block)(void));
FOUNDATION_EXTERN void kiriha_asyncMainBlock(double afterSecond, void (^block)(void)) __attribute__((overloadable));

FOUNDATION_EXTERN BOOL kiriha_isEmptyString(NSString *);
FOUNDATION_EXTERN BOOL kiriha_isNotEmptyString(NSString *);
FOUNDATION_EXTERN BOOL kiriha_isBlankString(NSString *);
FOUNDATION_EXTERN BOOL kiriha_isNotBlankString(NSString *);

#endif /* KCKFoundation_h */
