//
//  MKSZ202Course41Example1AppDelegate.m
//  MyStudyiOS
//
//  Created by 御前崎悠羽 on 2024/5/22.
//

#import "MKSZ202Course41Example1AppDelegate.h"
#import "MObject.h"
#import "MObserver.h"

@implementation MKSZ202Course41Example1AppDelegate

- (id)init {
    self = [super init];
    if (self) {
        MObject *obj = [[MObject alloc] init];
        MObserver *observer = [[MObserver alloc] init];
        
        // 调用 kvo 方法监听 obj 的 value 属性变化。
        // 如果在这里打印日志 `po object_getClassName(obj)`，结果为 `MObject`。所以此时对象名没变。
        [obj addObserver:observer forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:NULL];
        
        // 通过 setter 方法修改 value。
        // 程序走到这步时，再打印日志 `po object_getClassName(obj)`，结果为 `NSKVONotifying_MObject` 新类。
        // 这里体现了系统运行时动态创建了新类，还重写了 setter 方法。
        obj.value = 1;
        
        // 1：问：通过 kvc 设置 value 能否生效？
        // 答案：生效。
        // 涉及 kvc 和 kvo 的联系。
        // 问：为什么可以生效？
        // 答案：`[obj setValue]` 实际上最终会调用 obj 的 setter 方法，即 `obj.value = 2`。而 setter 方法刚已经被系统重写了，所以 kvc 与 kvo 进行了联系。
        [obj setValue:@2 forKey:@"value"];
        
        // 2：问：通过成员变量直接赋值 value 能否生效？
        // 答案：不生效。因为系统是根据重写的 setter 方法实现 kvo 的，直接调用成员变量的 setter 方法是不生效的。
        // 注意：请进入 `increase` 方法查看仿 KVO setter 重写的代码，可以使下面这行代码生效。
        [obj increase];
    }
    return self;
}

@end
