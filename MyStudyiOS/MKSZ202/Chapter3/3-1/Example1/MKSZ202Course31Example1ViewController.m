//
//  MKSZ202Course31Example1ViewController.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/20.
//

#import "MKSZ202Course31Example1ViewController.h"
#import "IndexedTableView.h"

@interface MKSZ202Course31Example1ViewController () <UITableViewDataSource, UITableViewDelegate, IndexedTableViewDataSource>
{
    IndexedTableView *tableView;
    UIButton *button;
    NSMutableArray *dataSource;
}
@end

@implementation MKSZ202Course31Example1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView = [[IndexedTableView alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height - 60) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 设置 tableView 的索引数据源。
    tableView.indexedDataSource = self;
    
    [self.view addSubview:tableView];
    
    // 创建一个按钮。
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"reloadTable" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 数据源。
    dataSource = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [dataSource addObject:@(i + 1)];
    }
}

- (NSArray<NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView {
    // 奇数次调用返回6个字母，偶数次调用返回11个。
    static BOOL change = NO;
    if (change) {
        change = NO;
        return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
    } else {
        change = YES;
        return @[@"A", @"B", @"C", @"D", @"E", @"F"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuseId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 如果重用池当中没有可重用的 cell，那么创建一个 cell。
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[dataSource objectAtIndex:indexPath.row] stringValue];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)doAction:(id)sender {
    NSLog(@"reloadData");
    [tableView reloadData];
}

@end
