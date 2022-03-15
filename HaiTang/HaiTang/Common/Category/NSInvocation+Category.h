//
//  NSInvocation+Category.h
//  MeiYi
//
//  Created by XQ on 2019/1/15.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (Category)

/**
 *  创建一个invocation
 *  param : target 响应对象
 *          selector 响应的方法
 *          params 传的参数
 */
+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector params:(NSArray *)params;

@end

NS_ASSUME_NONNULL_END
