//
//  UIButton+Category.h
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Category)
/**
 创建通用按钮（eg:登录、注册）
 */
+ (UIButton *)commonButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

/**
 *  设置文字在左，图片在右
 */
- (void)setTitleLeftSpace:(CGFloat)space;

/**
 *  设置文字在右，图片在左
 */
- (void)setTitleRightSpace:(CGFloat)space;

/**
 *  设置文字在上，图片在下
 */
- (void)setTitleUpSpace:(CGFloat)space;

/**
 *  设置文字在下，图片在上
 */
- (void)setTitleDownSpace:(CGFloat)space;

/**
 *  扩大点击区域
 */
- (void)expandClickAreaOfSuperView:(UIView *)superView target:(id)target section:(SEL)section;

@end

NS_ASSUME_NONNULL_END
