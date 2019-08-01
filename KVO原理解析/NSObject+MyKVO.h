//
//  NSObject+MyKVO.h
//  KVO原理解析
//
//  Created by GeekDuan on 2019/7/31.
//  Copyright © 2019 GeekDuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyKVOObserver : NSObject
@property (nonatomic, strong) id observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSKeyValueObservingOptions options;
+ (MyKVOObserver *)generator:(id)observer key:(NSString *)key options:(NSKeyValueObservingOptions)options;
@end

@interface NSObject (MyKVO)
- (void)my_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change;
- (void)my_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options;
- (void)my_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
@end

NS_ASSUME_NONNULL_END
