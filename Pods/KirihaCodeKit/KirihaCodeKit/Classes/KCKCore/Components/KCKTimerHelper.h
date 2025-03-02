//
//  KCKTimerHelper.h
//  KirihaCodeKit
//
//  Created by 御前崎悠羽 on 2024/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KCKTimerRuningProtocol <NSObject>

- (void)imy_timerRuning;

@end

@interface KCKTimerHelper : NSObject

///一秒为单位
+ (instancetype)defaultTimerHelper;

///多少间隔
+ (instancetype)timerHelperWithInterval:(NSTimeInterval)interval;
- (instancetype)initWithTimeInterval:(NSTimeInterval)interval;

@property (readonly, nonatomic) NSTimeInterval interval;

///obj 要实现 IMYTimerRuning
- (void)addTimerForObject:(id<KCKTimerRuningProtocol>)obj;
- (void)addTimerForBlock:(void (^)(void))block key:(NSString *)key;

- (void)removeTimerForObject:(id)obj;
- (void)removeTimerForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
