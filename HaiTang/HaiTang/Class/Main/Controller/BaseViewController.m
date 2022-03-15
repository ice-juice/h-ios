//
//  BaseViewController.m
//  EarnMoney
//
//  Created by 吴紫颖 on 2020/3/23.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomNavBar.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.pageSize = 10;
    self.showHUD = NO;
    [self setupBaseViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBarAppearance];
    [[AppDelegate sharedDelegate] forcedToUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.disableLeftSlip) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    [JYToastUtils dismiss];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController.viewControllers count] == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        if (self.disableLeftSlip) {
            if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }
    }
}

- (void)setupNavigationBarAppearance {
    // 设置导航栏背景图片和文字颜色大小
    [self.navigationController setNavigationBarHidden:YES];
    if (!_navBar) {
        self.navBar = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight)];
        [self.view addSubview:self.navBar];
        [self.navBar makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(0);
            make.height.equalTo(kNavBarHeight);
        }];
        WeakSelf
        self.navBar.onReturnBlock = ^{
            [weakSelf popViewController];
        };
        [self.view bringSubviewToFront:self.navBar];
        self.navBar.hiddenSeparateLine = YES;
        //如果不是主控制器，就隐藏导航栏返回键
        self.navBar.hiddenReturn = YES;
        if ([self.navigationController.viewControllers count] > 1) {
            self.navBar.hiddenReturn = NO;
        }
        [self setupNavigation];
    }
}

- (void)setupBaseViewController {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    if ([self.navigationController.viewControllers count] > 1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem arrowButtonItemWithImageName:@"return_black" target:self selector:@selector(popViewController)];

        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self setupNavigation];
    [self setupSubViews];
    [self setupEvents];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)setupSubViews {
    
}

- (void)setupNavigation {
    
}

- (void)setupEvents {
    
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTitle:(NSString *)title {
    self.navBar.title = title;
}

- (void)setHiddenNavBar:(BOOL)hiddenNavBar {
    _hiddenNavBar = hiddenNavBar;
    self.navBar.hidden = hiddenNavBar;
}

- (void)setHiddenTabBarImage:(BOOL)hiddenTabBarImage {
    _hiddenTabBarImage = hiddenTabBarImage;
    self.imgView.hidden = hiddenTabBarImage;
}

- (void)dealloc {
    kDeallocLogger
}

@end
