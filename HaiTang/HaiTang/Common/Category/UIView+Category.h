//
//  UIView+Category.h
//  Youku
//
//  Created by 吴紫颖 on 2020/5/18.
//  Copyright © 2020 吴紫颖. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Category)

- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
borderWidth:(CGFloat)borderWidth
borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners;

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)removeAllSubviews;

@end

NS_ASSUME_NONNULL_END
