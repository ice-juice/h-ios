//
//  PendingOrderBuyViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PendingOrderBuyViewController.h"
#import "FiatOrderDetailViewController.h"
#import "PendingOrderDetailViewController.h"

#import "PendingOrderBuyMainView.h"

#import "FiatMainViewModel.h"

@interface PendingOrderBuyViewController ()<PendingOrderBuyMainViewDelegate>
@property (nonatomic, strong) PendingOrderBuyMainView *mainView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation PendingOrderBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mainView updateView];
}

#pragma mark - PendingOrderBuyMainViewDelegate
- (void)submitOrder {
    //挂单购买
    [self.mainViewModel fetchPendingOrderPurchaseWithResult:^(BOOL success) {
        if (success) {
            PendingOrderDetailViewController *detailVC = [[PendingOrderDetailViewController alloc] init];
            detailVC.orderModel = self.mainViewModel.orderDetailModel;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.hiddenNavBar = YES;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (PendingOrderBuyMainView *)mainView {
    if (!_mainView) {
        _mainView = [[PendingOrderBuyMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (FiatMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[FiatMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
