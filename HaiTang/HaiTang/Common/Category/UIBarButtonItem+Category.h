//
//  UIBarButtonItem+Category.h
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Category)
/** 创建一个UIBarButtonItem: 返回箭头 */
+ (UIBarButtonItem *)arrowButtonItemWithImageName:(NSString *)imageName target:(id)target selector:(SEL)selector;

/** 创建一个UIBarButtonItem: 图片(使用系统的按钮) */
+ (UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName target:(id)target selector:(SEL)selector;

/** 创建一个UIBarButtonItem: 图片(使用自定义的按钮) */
+ (UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target selector:(SEL)selector;

/** 创建一个UIBarButtonItem: 文字 */
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
