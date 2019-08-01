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

static NSString * const kMyKVONotifying_ = @"MyKVONotifying_";
const char *kMyKVOObserversArray = "MyKVOObserversArray";

@implementation MyKVOObserver

+ (MyKVOObserver *)generator:(id)observer key:(NSString *)key options:(NSKeyValueObservingOptions)options {
    MyKVOObserver *o = [MyKVOObserver new];
    o.observer = observer;
    o.key = key;
    o.options = options;
    return o;
}

@end

@implementation NSObject (MyKVO)

#pragma mark - Public Methods

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
    if ([isaStr hasPrefix:kMyKVONotifying_]) {
        NSLog(@"isa已经修改");
        return;
    }
    
    // 3. 生成子类
    NSString *curClsName = [kMyKVONotifying_ stringByAppendingString:NSStringFromClass(self.class)];
    Class curCls = objc_allocateClassPair(self.class, [curClsName UTF8String], 0);
    objc_registerClassPair(curCls);
    if (curCls) {
        object_setClass(self, curCls);
    }
    
    // 4. 加方法：setter + class
    BOOL r = class_addMethod(self.class, setterSEL, (IMP)MyKVONotifying_Setter, "#@:@");
    if (!r) {
        NSLog(@"add setter failure");
    }
    r = class_addMethod(self.class, @selector(class), (IMP)MyKVONotifying_Class, "v@:");
    if (!r) {
        NSLog(@"add class failure");
    }
    
    // 5. 添加观察者数组
    NSMutableArray *obs = objc_getAssociatedObject(self, kMyKVOObserversArray);
    if (!obs) {
        obs = @[].mutableCopy;
        objc_setAssociatedObject(self, kMyKVOObserversArray, obs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [obs addObject:[MyKVOObserver generator:observer key:keyPath options:options]];
}

- (void)my_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    
}

#pragma mark - Private Methods
// @selecor(setName:) kvc取值 super
void MyKVONotifying_Setter(id self, SEL _cmd, NSString *value) {
    NSString *key = [[NSStringFromSelector(_cmd).lowercaseString stringByReplacingOccurrencesOfString:@"set" withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *oldVal = [self valueForKey:key];
    
    // call super
    struct objc_super supCls;
    supCls.receiver = self;
    supCls.super_class = class_getSuperclass(object_getClass(self));
    ((void (*)(void *, SEL, id))(void *)objc_msgSendSuper)(&supCls, _cmd, value);
    
    // call obsever
    NSMutableArray *obs = objc_getAssociatedObject(self, kMyKVOObserversArray);
    for (MyKVOObserver *ob in obs) {
        if ([ob.key isEqualToString:key]) {
            NSMutableDictionary *map = @{}.mutableCopy;
            if (ob.options & NSKeyValueObservingOptionOld) {
                map[NSKeyValueChangeOldKey] = oldVal;
            }
            if (ob.options & NSKeyValueObservingOptionNew) {
                map[NSKeyValueChangeNewKey] = value;
            }
            [ob.observer my_observeValueForKeyPath:key ofObject:self change:map];
        }
    }
    
}

Class MyKVONotifying_Class(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}
@end
