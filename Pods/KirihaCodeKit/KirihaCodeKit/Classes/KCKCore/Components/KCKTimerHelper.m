//
//  KCKTimerHelper.m
//  KirihaCodeKit
//
//  Created by 御前崎悠羽 on 2024/8/12.
//

#import "KCKTimerHelper.h"
#import "KCKFoundation.h"

@implementation KCKTimerHelper {
    NSTimeInterval timeInterval;
    NSHashTable *objectTable;
    NSMutableDictionary *blockMap;
    NSTimer *timer;
}

+ (instancetype)defaultTimerHelper {
    return [self timerHelperWithInterval:1];
}

+ (NSMapTable *)runingTimerMapTable {
    static NSMapTable *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = [NSMapTable strongToWeakObjectsMapTable];
    });
    return map;
}

+ (instancetype)timerHelperWithInterval:(NSTimeInterval)interval {
    NSMapTable *hashMap = [KCKTimerHelper runingTimerMapTable];
    @synchronized(hashMap) {
        NSInteger intKey = interval * 1000;
        KCKTimerHelper *timerHelper = [hashMap objectForKey:@(intKey)];
        if (timerHelper == nil) {
            timerHelper = [[self alloc] initPrivateWithTimeInterval:interval];
        }
        return timerHelper;
    }
}

- (instancetype)init {
    return [self initWithTimeInterval:1];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval {
    NSMapTable *hashMap = [KCKTimerHelper runingTimerMapTable];
    @synchronized(hashMap) {
        NSInteger intKey = interval * 1000;
        KCKTimerHelper *timerHelper = [hashMap objectForKey:@(intKey)];
        if (timerHelper) {
            self = nil;
            return timerHelper;
        }
        else {
            return [self initPrivateWithTimeInterval:interval];
        }
    }
}

- (instancetype)initPrivateWithTimeInterval:(NSTimeInterval)interval {
    self = [super init];
    if (self) {
        timeInterval = interval;
        objectTable = [NSHashTable weakObjectsHashTable];
        blockMap = [NSMutableDictionary dictionary];
        
        NSInteger intKey = interval * 1000;
        [[KCKTimerHelper runingTimerMapTable] setObject:self forKey:@(intKey)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)onAppBecomeActive:(NSNotification *)notification {
    [timer setFireDate:[NSDate date]];
}

- (void)onAppResignActive:(NSNotification *)notification {
    [timer setFireDate:[NSDate distantFuture]];
}

- (NSTimeInterval)interval {
    return timeInterval;
}

- (void)checkNeedStartTimer {
    if (timer == nil) {
        if (objectTable.count > 0 || blockMap.count > 0) {
            kiriha_asyncMainExecuteBlock(^{
                [self checkNeedStartTimer_main];
            });
        }
    }
}

- (void)checkNeedStartTimer_main {
    if (timer == nil) {
        if (objectTable.count > 0 || blockMap.count > 0) {
            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(_timerRuning) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            
            NSInteger intKey = timeInterval * 1000;
            [[KCKTimerHelper runingTimerMapTable] setObject:self forKey:@(intKey)];
        }
    }
}

- (void)checkNeedStopTimer {
    if (timer) {
        if (objectTable.count == 0 && blockMap.count == 0) {
            kiriha_asyncMainExecuteBlock(^{
                [self checkNeedStopTimer_main];
            });
        }
    }
}

- (void)checkNeedStopTimer_main {
    if (timer) {
        if (objectTable.count == 0 && blockMap.count == 0) {
            [timer invalidate];
            timer = nil;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [objectTable removeAllObjects];
    [blockMap removeAllObjects];
    [timer invalidate];
    timer = nil;
}

- (void)_timerRuning {
    @synchronized(self) {
        NSArray *objectArray = objectTable.allObjects;
        NSArray *blockArray = blockMap.allValues;
        
        for (id obj in objectArray) {
            [obj imy_timerRuning];
        }
        for (id obj in blockArray) {
            void (^block)(void) = obj;
            block();
        }
        
        [self checkNeedStopTimer];
    }
}

- (void)addTimerForObject:(id<KCKTimerRuningProtocol>)obj {
    if ([obj respondsToSelector:@selector(imy_timerRuning)] && [objectTable containsObject:obj] == NO) {
        @synchronized(self) {
            [objectTable addObject:obj];
            [self checkNeedStartTimer];
        }
    }
}

- (void)addTimerForBlock:(void (^)(void))block key:(NSString *)key {
    if (block && key) {
        @synchronized(self) {
            blockMap[key] = [block copy];
            [self checkNeedStartTimer];
        }
    }
}

- (void)removeTimerForObject:(id)obj {
    if (obj) {
        @synchronized(self) {
            [objectTable removeObject:obj];
        }
    }
}

- (void)removeTimerForKey:(NSString *)key {
    if (key) {
        @synchronized(self) {
            [blockMap removeObjectForKey:key];
        }
    }
}

- (void)fire {
    [timer fire];
}

@end
