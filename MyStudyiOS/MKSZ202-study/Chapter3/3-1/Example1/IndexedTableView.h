//
//  IndexedTableViewDataSource.h
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IndexedTableViewDataSource <NSObject>

// 获取一个 tableView 字母索引条的方法。
- (NSArray <NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView;

@end

@interface IndexedTableView : UITableView

@property (nonatomic, weak) id <IndexedTableViewDataSource> indexedDataSource;

@end

NS_ASSUME_NONNULL_END
