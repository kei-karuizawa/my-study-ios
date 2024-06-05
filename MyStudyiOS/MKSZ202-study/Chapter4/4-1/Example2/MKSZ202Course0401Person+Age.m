//
//  MKSZ202Course0401Person+Age.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/6/4.
//

#import "MKSZ202Course0401Person+Age.h"

@implementation MKSZ202Course0401Person (Age)

- (void)setAge:(NSInteger)age {
    //objc_setAssociatedObject(self, AgeKey, @(age), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)age {
    //return [objc_getAssociatedObject(self, AgeKey) integerValue];
    return 0;
    
}

@end
