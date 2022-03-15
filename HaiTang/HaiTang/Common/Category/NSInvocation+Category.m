//
//  NSInvocation+Category.m
//  MeiYi
//
//  Created by XQ on 2019/1/15.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import "NSInvocation+Category.h"

@implementation NSInvocation (Category)

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector params:(NSArray *)params {
    if (!target || !selector) {
        return nil;
    }
    
    NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        //selector为传进来的方法
        NSString *info = [NSString stringWithFormat:@"%@方法找不到", NSStringFromSelector(selector)];
        [NSException raise:@"方法调用出现异常" format:info, nil];
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    
    [params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation setArgument:&obj atIndex:idx + 2];
    }];
    
    return invocation;
}

@end
