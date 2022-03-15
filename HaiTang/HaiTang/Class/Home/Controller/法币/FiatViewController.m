//
//  FiatViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatViewController.h"
#import "AcceptorViewController.h"
#import "FiatOrderListViewController.h"
#import "ModifyPasswordViewController.h"
#import "FiatOrderDetailViewController.h"

#import "FiatMainView.h"

#import "AcceptorModel.h"
#import "FiatMainViewModel.h"

@interface FiatViewController ()<FiatMainViewDelegate>
@property (nonatomic, strong) FiatMainView *mainView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation FiatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchOrderListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Request Data
- (void)fetchOrderListData {
    //法币交易（我要购买、我要出售）列表
    [self.mainViewModel fetchOrderListWithResult:^(BOOL success, BOOL loadMore) {
        if (success) {
            [self.mainView updateView];
        }
        [self.mainView showFooterView:loadMore];
    }];
}

#pragma mark - FiatMainViewDelegate
- (void)tableViewWithCheckFiatOrder:(UITableView *)tableView {
    //我要购买、我要出售
    self.mainViewModel.pageNo = 1;
    [self fetchOrderListData];
}

- (void)tableViewWithCheckMineOrder:(UITableView *)tableView {
    //我的订单
    FiatOrderListViewController *fiatOrderVC = [[FiatOrderListViewController alloc] init];
    [self.navigationController pushViewController:fiatOrderVC animated:YES];
}

- (void)tableViewWithOrderBuy:(UITableView *)tableView {
    //下单购买
    [self.mainViewModel fetchOrderBuyWithResult:^(BOOL success) {
        if (success) {
            FiatOrderDetailViewController *detailVC = [[FiatOrderDetailViewController alloc] init];
            detailVC.orderNo = self.mainViewModel.orderNo;
            detailVC.pageType = @"BUY";
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }];
}

- (void)tableViewWithForgetPassword:(UITableView *)tableView {
    //忘记密码
    ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc] init];
    modifyPasswordVC.modifyType = ModifyTypeAssetsPassword;
    [self.navigationController pushViewController:modifyPasswordVC animated:YES];
}

- (void)tableViewWithOrderSell:(UITableView *)tableView {
    //下单出售
    [self.mainViewModel fetchOrderSellWithResult:^(BOOL success) {
        if (success) {
            FiatOrderDetailViewController *detailVC = [[FiatOrderDetailViewController alloc] init];
            detailVC.orderNo = self.mainViewModel.orderNo;
            detailVC.pageType = @"SELL";
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }];
}

- (void)pullUpHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo ++;
    [self fetchOrderListData];
}

- (void)pullDownHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo = 1;
    [self fetchOrderListData];
}

#pragma mark - Event Response
- (void)onBtnWithCheckAcceptorEvent:(UIButton *)btn {
    //承兑商
    AcceptorViewController *acceptorVC = [[AcceptorViewController alloc] init];
    [self.navigationController pushViewController:acceptorVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"法币交易", nil);
    
    UIButton *btnAcceptor = [UIButton buttonWithTitle:NSLocalizedString(@"承兑商", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kBoldFont(12) target:self selector:@selector(onBtnWithCheckAcceptorEvent:)];
    self.navBar.navRightView = btnAcceptor;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (FiatMainView *)mainView {
    if (!_mainView) {
        _mainView = [[FiatMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
