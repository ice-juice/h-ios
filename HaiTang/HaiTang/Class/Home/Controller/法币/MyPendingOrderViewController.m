//
//  MyPendingOrderViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "MyPendingOrderViewController.h"
#import "PendingOrderDetailViewController.h"

#import "MyPendingOrderMainView.h"

#import "FiatMainViewModel.h"

@interface MyPendingOrderViewController ()<MyPendingOrderMainViewDelegate>
@property (nonatomic, strong) MyPendingOrderMainView *mainView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation MyPendingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchMinePendingOrderListData];
}

#pragma mark - Request Data
- (void)fetchMinePendingOrderListData {
    [self.mainViewModel fetchMinePendingOrderListWithResult:^(BOOL success, BOOL loadMore) {
        if (success) {
            [self.mainView updateView];
        }
        [self.mainView showFooterView:loadMore];
    }];
}

#pragma mark - MyPendingOrderMainViewDelegate
- (void)pullUpHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo ++;
    [self fetchMinePendingOrderListData];
}

- (void)pullDownHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo = 1;
    [self fetchMinePendingOrderListData];
}

- (void)tableView:(UITableView *)tableView checkOrderDetail:(OrderModel *)orderModel {
    PendingOrderDetailViewController *detailVC = [[PendingOrderDetailViewController alloc] init];
    detailVC.orderModel = orderModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    NSString *title = self.orderType == 1 ? NSLocalizedString(@"我的挂单出售", nil) : NSLocalizedString(@"我的挂单购买", nil);
    self.navBar.title = title;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (MyPendingOrderMainView *)mainView {
    if (!_mainView) {
        _mainView = [[MyPendingOrderMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (FiatMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[FiatMainViewModel alloc] initWithOrderType:self.orderType];
    }
    return _mainViewModel;
}

@end
