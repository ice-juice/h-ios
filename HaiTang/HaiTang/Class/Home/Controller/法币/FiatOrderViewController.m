//
//  FiatOrderViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderViewController.h"
#import "FiatOrderDetailViewController.h"

#import "FiatOrderMainView.h"

#import "FiatMainViewModel.h"

@interface FiatOrderViewController ()<FiatOrderMainViewDelegate>
@property (nonatomic, strong) FiatOrderMainView *mainView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation FiatOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchMineOrderData];
}

#pragma mark - Request Data
- (void)fetchMineOrderData {
    //我的订单
    [self.mainViewModel fetchMineOrderListWithResult:^(BOOL success, BOOL loadMore) {
        if (success) {
            [self.mainView updateView];
        }
        [self.mainView showFooterView:loadMore];
    }];
}

#pragma mark - FiatOrderMainViewDelegate
- (void)tableView:(UITableView *)tableView checkOrderDetail:(NSString *)orderNo pageType:(nonnull NSString *)pageType {
    //订单详情
    FiatOrderDetailViewController *orderDetailVC = [[FiatOrderDetailViewController alloc] init];
    orderDetailVC.orderNo = orderNo;
    orderDetailVC.pageType = pageType;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)pullUpHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo ++;
    [self fetchMineOrderData];
}

- (void)pullDownHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo = 1;
    [self fetchMineOrderData];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.hidden = YES;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (FiatOrderMainView *)mainView {
    if (!_mainView) {
        _mainView = [[FiatOrderMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (FiatMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[FiatMainViewModel alloc] initWithOrderStatus:self.orderStatus orderType:self.orderType];
    }
    return _mainViewModel;
}

@end
