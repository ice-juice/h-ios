//
//  StatusHelper.m
//  Youku
//
//  Created by 吴紫颖 on 2020/5/18.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "StatusHelper.h"
#import <YYMemoryCache.h>
#import <YYImageCoder.h>
#import "NSBundle+Category.h"

@implementation StatusHelper
+ (NSBundle *)bundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ResoucesImage" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"ImageCache";
    });
    return cache;
}

+ (UIImage *)imageNamed:(NSString *)name {
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self bundle] pathForScaledResource:name ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    if (!image) return nil;
    [[self imageCache] setObject:image forKey:name];
    return image;
}

+ (UIImage *)imageWithPath:(NSString *)path {
    if (!path) return nil;
    UIImage *image = [[self imageCache] objectForKey:path];
    if (image) return image;
    if (path.pathScale == 1) {
        //查找 @2x @3x的图片
        NSArray *scales = [NSBundle preferredScales];
        for (NSNumber *scale in scales) {
            image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathScale:scale.floatValue]];
            if (image) break;
        }
    } else {
        image = [UIImage imageWithContentsOfFile:path];
    }
    if (image) {
        image = [image imageByDecoded];
        [[self imageCache] setObject:image forKey:path];
    }
    return image;
}

@end
