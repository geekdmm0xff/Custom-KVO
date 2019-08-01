//
//  Person.h
//  KVO原理解析
//
//  Created by GeekDuan on 2019/7/29.
//  Copyright © 2019 GeekDuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;

- (void)bindInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
