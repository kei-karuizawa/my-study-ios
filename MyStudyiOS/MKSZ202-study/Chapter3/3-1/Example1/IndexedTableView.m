//
//  IndexedTableViewDataSource.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/20.
//

#import "IndexedTableView.h"
#import "ViewReusePool.h"

// 这也是类拓展。
@interface IndexedTableView ()
{
    // 成员对象。
    UIView *containerView;
    ViewReusePool *reusePool;
}

@end

@implementation IndexedTableView

- (void)reloadData {
    [super reloadData];
    
    // 懒加载。真正使用时才创建。
    if (containerView == nil) {
        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.backgroundColor = [UIColor whiteColor];
    }
    
    // 避免索引条随着 tableView 滚动（如果不写呢？）。
    [self.superview insertSubview:containerView aboveSubview:self];
    
    if (reusePool == nil) {
        reusePool = [[ViewReusePool alloc] init];
    }
    
    // 标记所有视图为可重用状态。
    [reusePool reset];
    
    // reload 字母索引条。
    [self reloadIndexedBar];
}

- (void)reloadIndexedBar {
    // 获取字母索引条的显示内容。
    NSArray <NSString *> *arrayTitles = nil;
    if ([self.indexedDataSource respondsToSelector:@selector(indexTitlesForIndexTableView:)]) {
        arrayTitles = [self.indexedDataSource indexTitlesForIndexTableView:self];
    }
    
    // 判断字母索引条是否为空。
    if (!arrayTitles || arrayTitles.count <= 0) {
        [containerView setHidden:YES];
        return;
    }
    
    NSUInteger count = arrayTitles.count;
    CGFloat buttonWidth = 60;
    CGFloat buttonHeight = self.frame.size.height / count;
    
    for (int i = 0; i < [arrayTitles count]; i++) {
        NSString *title = [arrayTitles objectAtIndex:i];
        
        // 从重用池当中取一个 button 出来。
        UIButton *button = (UIButton *)[reusePool dequeueReuseableView];
        // 如果没有可重用的 button 则重新创建一个。
        if (button == nil) {
            button = [[UIButton alloc] initWithFrame:CGRectZero];
            button.backgroundColor = [UIColor whiteColor];
            
            // 注册 button 到重用池中。
            [reusePool addUsingView:button];
            NSLog(@"新创建一个 button");
        } else {
            NSLog(@"button 重用了");
        }
        
        // 添加 button 到父视图。
        [containerView addSubview:button];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置 button 坐标。
        [button setFrame:CGRectMake(0, i * buttonHeight, buttonWidth, buttonHeight)];
    }
    
    [containerView setHidden:NO];
    containerView.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - buttonWidth, self.frame.origin.y, buttonWidth, self.frame.size.height);
}

@end
