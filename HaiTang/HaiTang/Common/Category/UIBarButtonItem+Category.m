//
//  UIBarButtonItem+Category.m
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "UIBarButtonItem+Category.h"

@implementation UIBarButtonItem (Category)
/** 创建一个UIBarButtonItem: 返回箭头 */
+ (UIBarButtonItem *)arrowButtonItemWithImageName:(NSString *)imageName target:(id)target selector:(SEL)selector {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:target action:selector];
    return item;
}

/** 创建一个UIBarButtonItem: 图片(使用系统的按钮) */
+ (UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName target:(id)target selector:(SEL)selector {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:target action:selector];
    return item;
}

/** 创建一个UIBarButtonItem: 图片(使用自定义的按钮) */
+ (UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target selector:(SEL)selector {
    UIButton *button = [[UIButton alloc] init];
    if (imageName.length) {
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }

    if (highlightedImageName.length) {
        [button setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }

    CGRect btnFrame = button.frame;
    btnFrame.size = button.currentBackgroundImage.size;
    button.frame = btnFrame;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/** 创建一个UIBarButtonItem: 文字 */
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target selector:(SEL)selector {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    [barButtonItem setTitleTextAttributes:@{ NSFontAttributeName : font,
                                             NSForegroundColorAttributeName : titleColor }
                                 forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:@{ NSFontAttributeName : font,
                                             NSForegroundColorAttributeName : titleColor }
                                 forState:UIControlStateSelected];
    [barButtonItem setTitleTextAttributes:@{ NSFontAttributeName : font,
                                             NSForegroundColorAttributeName : titleColor }
                                 forState:UIControlStateSelected];
    return  barButtonItem;
}

@end
