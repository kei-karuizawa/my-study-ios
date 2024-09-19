//
//  ViewReusePool.h
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 实现重用机制的类。
@interface ViewReusePool : NSObject

// 从重用池中取出一个可重用的 view。
- (UIView *)dequeueReuseableView;

// 向重用池当中添加一个视图。
- (void)addUsingView:(UIView *)view;

// 重置方法，将当前使用中的视图移动到可重用队列当中。
- (void)reset;

@end

NS_ASSUME_NONNULL_END
