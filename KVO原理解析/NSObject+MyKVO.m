//
//  NSObject+MyKVO.m
//  KVO原理解析
//
//  Created by GeekDuan on 2019/7/31.
//  Copyright © 2019 GeekDuan. All rights reserved.
//

#import "NSObject+MyKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString * const MyKVONotifying_ = @"MyKVONotifying_";

@implementation NSObject (MyKVO)

- (void)my_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {

}

- (void)my_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options {
    // 1. 检测 key 是否存在 -> 是否存在 setter 方法
    NSString *setterName = [NSString stringWithFormat:@"set%@:", [keyPath capitalizedString]];
    SEL setterSEL = NSSelectorFromString(setterName);
    Method setterMethod = class_getInstanceMethod(self.class, setterSEL);
    if (!setterMethod) {
        NSLog(@"当前key不存在:%@", keyPath);
        return;
    }
    
    // 2. 检测是否已经替换了 isa
    Class isaCls = object_getClass(self);
    NSString *isaStr = NSStringFromClass(isaCls);
    if ([isaStr hasPrefix:MyKVONotifying_]) {
        NSLog(@"isa已经修改");
        return;
    }
    
    // 3. 生成子类
    NSString *curClsName = [MyKVONotifying_ stringByAppendingString:NSStringFromClass(self.class)];
    Class curCls = objc_allocateClassPair(self.class, [curClsName UTF8String], 0);
    objc_registerClassPair(curCls);
    if (curCls) {
        object_setClass(self, curCls);
    }
}

- (void)my_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    
}

@end
