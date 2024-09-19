//
//  OCOfficialStudy02Example1XYZPerson.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/7/21.
//

#import "OCOfficialStudy02Example1XYZPerson.h"

@implementation OCOfficialStudy02Example1XYZPerson

- (void)sayHello {
    [self saySomeThing:@"hello world!"];
}

- (void)saySomeThing:(NSString *)greeting {
    NSLog(@"%@", greeting);
}

@end
