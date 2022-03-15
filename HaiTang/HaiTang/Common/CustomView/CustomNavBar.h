//
//  CustomNavBar.h
//  MeiYi
//
//  Created by XQ on 2019/1/22.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavReturnType) {
    NavReturnTypeWhite,     // 白色返回按钮
    NavReturnTypeBlack      // 黑色返回按钮
};
NS_ASSUME_NONNULL_BEGIN

@interface CustomNavBar : UIView
/** 设置title颜色，默认白色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 设置title字体，默认kFont(18) */
@property (nonatomic, strong) UIFont *titleFont;
/** 设置title文字 */
@property (nonatomic, copy) NSString *title;
/** 设置背景色，默认黑色 */
@property (nonatomic, strong) UIColor *navBackgroundColor;
/** 设置背景图片，默认nil */
@property (nonatomic, strong) UIImage *navBackgroundImage;
/** 设置返回按钮颜色，默认白色 */
@property (nonatomic, assign) NavReturnType returnType;
/** 设置titleView，默认nil */
@property (nonatomic, strong) UIView *titleView;
/** 设置分割线颜色，默认kSeparateLineColor */
@property (nonatomic, strong) UIColor *separateColor;
/** 设置分割线高度，默认0.5 */
@property (nonatomic, assign) CGFloat separateHeight;
/** 设置是否隐藏返回按钮，默认NO */
@property (nonatomic, assign) BOOL hiddenReturn;
/** 设置是否隐藏分割线，默认NO */
@property (nonatomic, assign) BOOL hiddenSeparateLine;
/** 设置返回响应事件 */
@property (nonatomic, copy) void(^onReturnBlock)(void);
/** 设置右侧view */
@property (nonatomic, strong) UIView *navRightView;
/** 设置左侧View */
@property (nonatomic, strong) UIView *navLeftView;
/** 设置左侧View 有返回箭头 */
@property (nonatomic, strong) UIView *navSubLeftView;
@end

NS_ASSUME_NONNULL_END
