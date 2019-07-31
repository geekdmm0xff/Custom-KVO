//
//  main.m
//  KVO原理解析
//
//  Created by GeekDuan on 2019/7/29.
//  Copyright © 2019 GeekDuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFRuntimeKit.h"
#import "Person.h"
#import "NSObject+MyKVO.h"

void showInfos(Person *p) {
    Class isa = object_getClass(p);
    NSArray *methos = [CFRuntimeKit fetchMethodList:isa];
    NSArray *propertys = [CFRuntimeKit fetchPropertyList:isa];
    NSArray *ivars = [CFRuntimeKit fetchIvarList:isa];
    NSLog(@"isa: %@", isa);
    NSLog(@"methos: %@", methos);
    NSLog(@"propertys: %@", propertys);
    NSLog(@"ivars: %@", ivars);
    NSLog(@"class:%@", [p class]);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        Person *p = [Person new];
//        NSLog(@"======before=====");
//        showInfos(p);
//
//        NSLog(@"======observer======");
//        [p addObserver:p forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//        showInfos(p);
//
//        NSLog(@"======remove======");
//        [p removeObserver:p forKeyPath:@"name"];
//        showInfos(p);
        
        {
//            Person *p = [Person new];
//            [p addObserver:p forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//            [p addObserver:p forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//            p.name = @"geek";
//            p.age = 10;
//            p.name = @"geek";
//            [p bindInfo:@{
//                          @"name": @"dmm",
//                          @"age": @(26)
//                          }];
        }
        
        
        {
            Person *p = [Person new];
            NSLog(@"class:%@ isa:%@", p.class, object_getClass(p));
            [p my_addObserver:p forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld];
            NSLog(@"class:%@ isa:%@", p.class, object_getClass(p));

        }
    }
    return 0;
}
