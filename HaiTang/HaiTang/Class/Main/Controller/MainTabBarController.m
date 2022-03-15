//
//  MainTabBarController.m
//  iShop
//
//  Created by JY on 2018/6/7.
//  Copyright © 2018年 帝辰科技. All rights reserved.
//  

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "ContractViewController.h"
#import "CoinViewController.h"
#import "AssetsViewController.h"
#import "BaseNavigationViewController.h"

#import "InvitationLinkViewController.h"

@interface MainTabBarController () <UITabBarDelegate, UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self setupViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

/** 设置主控制器 */
- (void)setupViewController {
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addChildViewController:homeVC title:NSLocalizedString(@"首页", nil) image:@"tabbar_home" selectedImage:@"tabbar_home_sel"];
    
    ContractViewController *contractVC = [[ContractViewController alloc] init];
    [self addChildViewController:contractVC title:NSLocalizedString(@"合约", nil) image:@"tabbar_contract" selectedImage:@"tabbar_contract_sel"];
    
    CoinViewController *coinVC = [[CoinViewController alloc] init];
    [self addChildViewController:coinVC title:NSLocalizedString(@"币币", nil) image:@"tabbar_coin" selectedImage:@"tabbar_coin_sel"];
    
    AssetsViewController *assetsVC = [[AssetsViewController alloc] init];
    [self addChildViewController:assetsVC title:NSLocalizedString(@"资产", nil) image:@"tabbar_assets" selectedImage:@"tabbar_assets_sel"];
    
    // TODO: 设置其他控制器
}

- (void)addChildViewController:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    childVC.title = title;

    childVC.tabBarItem.title = title;

    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationViewController *navController = [[BaseNavigationViewController alloc] initWithRootViewController:childVC];
    [self addChildViewController:navController];
}

#pragma mark - Tabbar Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
//        if (![[BLAppDelegate sharedDelegate] isLogin]) {
//            [[BLAppDelegate sharedDelegate] showModalLoginPage];
//            return NO;
//        }
//    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTabbarClick];
}

@end
