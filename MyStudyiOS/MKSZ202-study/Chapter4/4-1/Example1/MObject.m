//
//  MObject.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/22.
//

#import "MObject.h"

@implementation MObject

- (id)init {
    self = [super init];
    if (self) {
        _value = 0;
    }
    return self;
}

- (void)increase {
    // 直接调用成员变量不触发 KVO。
    _value += 1;
    
    // 下面仿写 KVO 系统重写的 setter 方法实现。这样可以触发 KVO。即手动 KVO。
//    [self willChangeValueForKey:@"value"];
//    _value += 1;
//    [self didChangeValueForKey:@"value"];
}

@end
