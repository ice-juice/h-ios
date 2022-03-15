//
//  BaseViewController.h
//  EarnMoney
//
//  Created by 吴紫颖 on 2020/3/23.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavBar.h"

@class EmptyView;

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, assign) BOOL showHUD;
@property (nonatomic, assign) BOOL disableLeftSlip;     // 禁止侧滑
@property (nonatomic, strong) CustomNavBar *navBar;
@property (nonatomic, assign) BOOL hiddenNavBar;
@property (nonatomic, assign) BOOL hiddenTabBarImage;
@property (nonatomic, strong) UIImageView *imgView;
/** 默认每页条数 */
@property (nonatomic, assign) NSInteger pageSize;
/** 当前页码, 从1开始 */
@property (nonatomic, assign) NSInteger pageNo;

/* 子类重写该方法绘制UI */
- (void)setupSubViews;

/* 子类重写导航栏 */
- (void)setupNavigation;

/* 子类重写添加响应事件 */
- (void)setupEvents;

/* 子类重写该方法POP页面 */
- (void)popViewController;

@end

NS_ASSUME_NONNULL_END
