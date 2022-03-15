//
//  NSObject+Category.m
//  MeiYi
//
//  Created by XQ on 2019/2/16.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import "NSObject+Category.h"

@implementation NSObject (Category)

/* 映射对象 */
+ (id)mapperObjectWithResult:(id)resultDict mapper:(id)mapper {
    
    id mapperObject = nil;
    if (!mapper || mapper == [NSDictionary class] || mapper == [NSArray class]) {
        return resultDict;
    }
    
    if ([resultDict isKindOfClass:[NSDictionary class]]) {
        id model = [[mapper alloc] init];
        [model mj_setKeyValues:resultDict];
        mapperObject = model;
        
    } else if ([resultDict isKindOfClass:[NSArray class]]) {
        NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:[resultDict count]];
        for (id objDict in resultDict) {
            if ([objDict isKindOfClass:[NSString class]] || [objDict isKindOfClass:[NSValue class]]) {
                [modelArray addObject:objDict];
                
            } else {
                id model = [[mapper alloc] init];
                [model mj_setKeyValues:objDict];
                [modelArray addObject:model];
            }
        }
        mapperObject = modelArray;
        
    } else if (mapper == [NSString class]) {
        mapperObject = [NSString stringWithFormat:@"%@", resultDict];
        
    } else {
        mapperObject = resultDict;
    }
    
    return mapperObject;
}

/** 判断对象是否为空 */
+ (BOOL)isEmptyWithObject:(id)object {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

// 获取当前显示的栈顶控制器
+ (UIViewController *)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];

    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];

    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];

    } else {
        return rootViewController;
    }
}

@end
