//
//  OCOfficialStudy02Example1XYZPerson.h
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCOfficialStudy02Example1XYZPerson : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSDate *birthDay;

- (void)sayHello;
- (void)saySomeThing:(NSString *)greeting;
+ (void)person;

@end

NS_ASSUME_NONNULL_END
