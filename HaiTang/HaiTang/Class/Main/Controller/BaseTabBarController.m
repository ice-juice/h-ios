//
//  BaseTabBarController.m
//  iShop
//
//  Created by JY on 2018/6/7.
//  Copyright © 2018年 帝辰科技. All rights reserved.
//  TabBar控制器基类

#import "BaseTabBarController.h"

#import "StatusHelper.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarAppearance];
}

- (void)setupTabBarAppearance {
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : kFont(10),
                                                         NSForegroundColorAttributeName :  kTabBarTitleColor}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : kFont(10),
                                                         NSForegroundColorAttributeName : kTabBarSelectedTitleColor }
                                             forState:UIControlStateSelected];

    
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.shadowImage = [UIImage new];
    //解决tabbar会莫名其妙变成蓝色问题；
    self.tabBar.tintColor = kTabBarSelectedTitleColor;
    
    //添加阴影
    self.tabBar.layer.shadowColor = kHexRGB(0x000000).CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -2);
    self.tabBar.layer.shadowOpacity = 0.04;
    // 顶部分割线
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.05)];
////    lineView.backgroundColor = kSeparateLineColor;
//    [self.tabBar addSubview:lineView];
}

@end
