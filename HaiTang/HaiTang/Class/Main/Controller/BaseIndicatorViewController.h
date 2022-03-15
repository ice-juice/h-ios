//
//  BaseIndicatorViewController.h
//  iShop
//
//  Created by JY on 2018/6/7.
//  Copyright © 2018年 帝辰科技. All rights reserved.
//

#import <WMPageController/WMPageController.h>

#import "CustomNavBar.h"

#define kMenuHeight 46

@interface BaseIndicatorViewController : WMPageController

@property (nonatomic, strong) CustomNavBar *navBar;

@property (nonatomic, assign) BOOL hiddenNavBar;

/** 菜单背景颜色 */
@property (nonatomic, strong) UIColor *menuBGColor;

/* 子类重写导航栏 */
- (void)setupNavigation;

/* 子类重写该方法绘制UI */
- (void)setupSubViews;

/* 子类重写添加响应事件 */
- (void)setupEvents;

@end
