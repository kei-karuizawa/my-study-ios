//
//  MObserver.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/22.
//

#import "MObserver.h"
#import "MObject.h"

@implementation MObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[MObject class]] && [keyPath isEqualToString:@"value"]) {
        // 获取 value 新值。
        NSNumber *valueNum = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"value is %@", valueNum);
    }
}

@end
