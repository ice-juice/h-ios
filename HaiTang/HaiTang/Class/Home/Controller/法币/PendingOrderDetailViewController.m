//
//  PendingOrderDetailViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PendingOrderDetailViewController.h"

#import "PendingOrderDetailView.h"

#import "FiatMainViewModel.h"

@interface PendingOrderDetailViewController ()<PendingOrderDetailViewDelegate>
@property (nonatomic, strong) PendingOrderDetailView *mainView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation PendingOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

#pragma mark - PendingOrderDetailViewDelegate
- (void)cancelOrder {
    //撤单
    [self.mainViewModel fetchCancelPendingOrderWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"操作成功", nil) completionHandle:^{
                [self popViewController];
            }];
        }
    }];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.returnType = NavReturnTypeWhite;
    self.navBar.navBackgroundColor = kRGB(0, 125, 255);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Setter & getter
- (PendingOrderDetailView *)mainView {
    if (!_mainView) {
        _mainView = [[PendingOrderDetailView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (FiatMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[FiatMainViewModel alloc] initWithOrderDetailModel:self.orderModel];
    }
    return _mainViewModel;
}

@end
