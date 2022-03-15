//
//  NSObject+Category.h
//  MeiYi
//
//  Created by XQ on 2019/2/16.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Category)

/** 映射对象,字典转模型 */
+ (id)mapperObjectWithResult:(id)resultDict mapper:(id)mapper;

/** 判断对象为空 */
+ (BOOL)isEmptyWithObject:(id)object;

/** 获取当前显示的栈顶控制器 */
+ (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
