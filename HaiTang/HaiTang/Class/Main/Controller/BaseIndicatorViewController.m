//
//  BaseIndicatorViewController.m
//  iShop
//
//  Created by JY on 2018/6/7.
//  Copyright © 2018年 帝辰科技. All rights reserved.
//

#import "BaseIndicatorViewController.h"

#import "StatusHelper.h"

@interface BaseIndicatorViewController ()

@end

@implementation BaseIndicatorViewController
#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 14;
        self.titleSizeNormal = 14;
        self.menuItemWidth = kScreenWidth / 3;
        self.titleColorNormal = kRGB(153, 153, 153);
        self.titleColorSelected = kRGB(0, 102, 237);
        self.progressColor = [UIColor blackColor];
        self.progressHeight = 4;
        self.menuBGColor = kRGB(27, 28, 33);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollEnable = NO;
    // 设置导航栏返回按钮图片
    self.view.backgroundColor = kRGB(16, 15, 20);
    if ([self.navigationController.viewControllers count] > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self setupSubViews];
    [self setupEvents];
    [self setupNavigation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBarAppearance];
}

- (void)dealloc {
    kDeallocLogger
}

#pragma mark - WMPageControllerDelegate
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 87, self.view.frame.size.width, 45);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

#pragma mark - Private Method
- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)wm_addMenuView {
    WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:CGRectZero];
    menuView.delegate = self;
    menuView.dataSource = self;
    menuView.style = self.menuViewStyle;
    menuView.layoutMode = WMMenuViewLayoutModeLeft;
    menuView.progressHeight = self.progressHeight;
    menuView.contentMargin = self.menuViewContentMargin;
    menuView.progressViewBottomSpace = self.progressViewBottomSpace;
    menuView.progressWidths = self.progressViewWidths;
    menuView.progressViewIsNaughty = self.progressViewIsNaughty;
    menuView.progressViewCornerRadius = self.progressViewCornerRadius;
    menuView.showOnNavigationBar = self.showOnNavigationBar;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        self.navigationItem.titleView = menuView;
    } else {
        [self.view addSubview:menuView];
    }
    self.menuView = menuView;
    self.menuView.backgroundColor = _menuBGColor;
}

- (void)setupNavigationBarAppearance {
    [self.navigationController setNavigationBarHidden:YES];
    self.navBar = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
    [self.view addSubview:self.navBar];
    [self.navBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(self.view);
        make.height.equalTo(kNavBarHeight);
    }];
    WeakSelf
    self.navBar.onReturnBlock = ^{
        [weakSelf popViewController];
    };
    [self.view bringSubviewToFront:self.navBar];
    // 如果不是主控制器，就隐藏导航栏返回键
    self.navBar.hiddenReturn = YES;
    self.navBar.hiddenSeparateLine = YES;
    if ([self.navigationController.viewControllers count] > 1) {
        self.navBar.hiddenReturn = NO;
    }
    [self setupNavigation];
}

#pragma mark - Gettger/Setter
- (void)setupNavigation {
    
}

- (void)setupSubViews {
    
}

- (void)setupEvents {
    
}

- (void)setMenuBGColor:(UIColor *)menuBGColor {
    _menuBGColor = menuBGColor;
    self.menuView.backgroundColor = menuBGColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    self.menuView.lineColor = progressColor;
}

- (void)setTitle:(NSString *)title {
    self.navBar.title = title;
}

- (void)setHiddenNavBar:(BOOL)hiddenNavBar {
    _hiddenNavBar = hiddenNavBar;
    
    self.navBar.hidden = hiddenNavBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
