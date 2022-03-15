//
//  PendingOrderListViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PendingOrderListViewController.h"
#import "PendingOrderSellViewController.h"
#import "PendingOrderBuyViewController.h"

@interface PendingOrderListViewController ()
@property (nonatomic, strong) NSArray *arrayIndicatorDatas;

@end

@implementation PendingOrderListViewController
#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeSelected = 20;
        self.titleSizeNormal = 16;
    }
    return self;
}

#pragma mark - WMPageController DataSource
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, kNavBarHeight, self.view.frame.size.width, 47);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return [self.arrayIndicatorDatas count];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        return [PendingOrderBuyViewController new];
    } else {
        return [PendingOrderSellViewController new];
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.arrayIndicatorDatas[index];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"我要挂单", nil);
}

- (void)setupSubViews {
    self.progressColor = [UIColor clearColor];
    self.menuBGColor = [UIColor whiteColor];
    self.menuItemWidth = 100;
    [self.menuView reload];
}

#pragma mark - Setter And Getter
- (NSArray *)arrayIndicatorDatas {
    if (!_arrayIndicatorDatas) {
        _arrayIndicatorDatas = @[@"挂单购买", @"挂单出售"];
    }
    
    return _arrayIndicatorDatas;
}

@end
