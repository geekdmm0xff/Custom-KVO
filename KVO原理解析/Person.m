//
//  Person.m
//  KVO原理解析
//
//  Created by GeekDuan on 2019/7/29.
//  Copyright © 2019 GeekDuan. All rights reserved.
//

#import "Person.h"

@implementation Person

//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    if ([key isEqualToString:@"name"] ||
//        [key isEqualToString:@"age"]) {
//        return NO;
//    }
//    return [super automaticallyNotifiesObserversForKey:key];
//}

- (void)setName:(NSString *)name {
    if (_name != name) {
        [self willChangeValueForKey:@"name"];
        _name = name;
        [self didChangeValueForKey:@"name"];
    }
}

- (void)setAge:(NSString *)age {
    if (_age != age) {
        [self willChangeValueForKey:@"age"];
        _age = age;
        [self didChangeValueForKey:@"age"];
    }
}

- (void)bindInfo:(NSDictionary *)info {
    NSString *name = info[@"name"];
    NSString *age = info[@"age"];
    
    [self willChangeValueForKey:@"name"];
    [self willChangeValueForKey:@"age"];
    _name = name;
    _age = age;
    [self didChangeValueForKey:@"name"];
    [self didChangeValueForKey:@"age"];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", keyPath);
}

- (void)my_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    NSLog(@"%@ %@", keyPath, change);

}
@end
