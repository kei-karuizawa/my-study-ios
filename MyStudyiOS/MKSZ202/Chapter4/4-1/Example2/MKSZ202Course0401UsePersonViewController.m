//
//  MKSZ202Course0401UsePersonViewController.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/6/4.
//

#import "MKSZ202Course0401UsePersonViewController.h"
#import "MKSZ202Course0401Person.h"
#import "MKSZ202Course0401Person+Age.h"

@interface MKSZ202Course0401UsePersonViewController ()

@end

@implementation MKSZ202Course0401UsePersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MKSZ202Course0401Person *person = [[MKSZ202Course0401Person alloc] init];
    person.name = @"11";
    person.age = 13;
    NSLog(@"Name: %@, Age: %ld", person.name, person.age);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
