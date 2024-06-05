//
//  MKSZ202Course0401Person+Age.h
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/6/4.
//

#import "MKSZ202Course0401Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKSZ202Course0401Person (Age)

// 注意：直接在这里添加属性，在 .m 文件中没有任何实现时，运行报错：
// '-[MKSZ202Course0401Person setAge:]: unrecognized selector sent to instance 0x60000000c430'。
// 在分类中不会生成实例变量 _age，所以在 .m 文件中你获取不到 age。
// 这里相当于只是声明了 getter 和 setter 方法而没有具体实现。
@property (nonatomic, assign) NSInteger age;


@end

NS_ASSUME_NONNULL_END
