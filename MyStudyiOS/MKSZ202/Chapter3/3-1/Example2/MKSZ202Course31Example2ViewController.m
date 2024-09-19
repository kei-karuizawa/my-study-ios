//
//  MKSZ202Course31Example2ViewController.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/21.
//

#import "MKSZ202Course31Example2ViewController.h"
#import "CustomButton.h"

@interface MKSZ202Course31Example2ViewController ()
{
    CustomButton *cornerButton;
}

@end

@implementation MKSZ202Course31Example2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cornerButton = [[CustomButton alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];
    cornerButton.backgroundColor = [UIColor blueColor];
    [cornerButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cornerButton];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)doAction:(id)sender {
    NSLog(@"click");
}

@end
