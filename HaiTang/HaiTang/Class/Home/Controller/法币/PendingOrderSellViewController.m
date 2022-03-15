//
//  PendingOrderSellViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PendingOrderSellViewController.h"
#import "AddPaymentViewController.h"
#import "PendingOrderDetailViewController.h"

#import "PendingOrderSellMainView.h"

#import "FiatMainViewModel.h"

@interface PendingOrderSellViewController ()<PendingOrderSellMainViewDelegate>
@property (nonatomic, strong) PendingOrderSellMainView *mainView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation PendingOrderSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchSellInfoData];
}

#pragma mark - Request Data
- (void)fetchSellInfoData {
    //挂单出售页面信息
    [self.mainViewModel fetchPendingOrderSellInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - PendingOrderSellMainViewDelegate
- (void)addPaymentWithIndexPath:(NSIndexPath *)indexPath {
    //添加收款方式
    AddPaymentViewController *addVC = [[AddPaymentViewController alloc] init];
    addVC.addPaymentType = AddPaymentTypeBankCard;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)submitPendingOrderSell {
    //挂单出售
    [self.mainViewModel fetchPendingOrderSellWithResult:^(BOOL success) {
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
- (PendingOrderSellMainView *)mainView {
    if (!_mainView) {
        _mainView = [[PendingOrderSellMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
