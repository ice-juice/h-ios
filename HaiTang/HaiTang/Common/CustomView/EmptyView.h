//
//  EmptyView.h
//  iShop
//
//  Created by XQ on 2018/6/14.
//  Copyright © 2018年 XQ. All rights reserved.
//  页面没有数据时的提示控件

#import <UIKit/UIKit.h>

@interface EmptyView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIColor *titleColor;
/**
 初始化的方法
 @param superView 父视图
 @param title 提示的字符串
 @param imageName 提示的图片名字
 */
- (instancetype)initWithSuperView:(UIView *)superView title:(NSString *)title imageName:(NSString *)imageName;
/**
 初始化的方法
 @param superView 父视图
 @param title 提示的字符串
 @param imageName 提示的图片名字
 @param titleColor 提示的文字颜色
 */
- (instancetype)initWithSuperView:(UIView *)superView title:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor;
/**
 初始化的方法
 @param superView 父视图
 @param title 提示的字符串
 @param imageName 提示的图片名字
 @param imageSize 图片大小
 */
- (instancetype)initWithSuperView:(UIView *)superView title:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor imageSize:(CGSize)imageSize;
/**
 初始化的方法
 @param frame 控件大小
 @param superView 父视图
 @param title 提示的字符串
 @param imageName 提示的图片名字
@param imageSize 图片大小
 */
- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView title:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor imageSize:(CGSize)imageSize;
@end
