//
//  StatusHelper.h
//  Youku
//
//  Created by 吴紫颖 on 2020/5/18.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYMemoryCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatusHelper : NSObject
/// 图片资源bundle
+ (NSBundle *)bundle;

/// 图片cache
+ (YYMemoryCache *)imageCache;

/// 从图片bundle里获取图片(有缓存)
+ (UIImage *)imageNamed:(NSString *)name;

/// 从path创建图片(有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

/// 圆角头像的manager
@end

NS_ASSUME_NONNULL_END
