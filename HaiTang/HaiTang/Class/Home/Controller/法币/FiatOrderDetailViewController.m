//
//  FiatOrderDetailViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderDetailViewController.h"
#import "AppealViewController.h"
#import "ModifyPasswordViewController.h"

#import "FiatOrderDetailMainView.h"
#import "MarginPopupView.h"

#import "OrderModel.h"
#import "FiatMainViewModel.h"

@interface FiatOrderDetailViewController ()<FiatOrderDetailMainViewDelegate>
@property (nonatomic, strong) FiatOrderDetailMainView *mainView;
@property (nonatomic, strong) MarginPopupView *cancelPopupView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation FiatOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchOrderDetailData];
}

- (void)dealloc {
    kDeallocLogger
    [self.mainViewModel stopCountDown];
}

#pragma mark - Request Data
- (void)fetchOrderDetailData {
    [self.mainViewModel fetchOrderInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

- (void)cancelOrderTip {
    //取消订单前获取提示信息
    [self.mainViewModel fetchOrderCancelTipWithResult:^(BOOL success, NSString *msg) {
        if (success) {
            if ([NSString isEmpty:msg]) {
                [self.cancelPopupView setViewWithModel:@"您正在操作取消订单，请确保您未参与此订单付款，是否继续取消？"];
            } else {
                NSString *cancelMsg = [NSString stringWithFormat:@"您今日已取消2次，如再次取消，%@分钟内无法下单购买，是否继续取消？", msg];
                [self.cancelPopupView setViewWithModel:cancelMsg];
            }
        } else {
            if (![NSString isEmpty:msg]) {
                NSString *cancelMsg = [NSString stringWithFormat:@"您今日已取消2次，如再次取消，%@分钟内无法下单购买，是否继续取消？", msg];
                [self.cancelPopupView setViewWithModel:cancelMsg];
            }
        }
    }];
}

- (void)cancelOrder {
    //取消订单
    [self.mainViewModel fetchOrderCancelWithResult:^(BOOL success) {
        if (success) {
            [self fetchOrderDetailData];
        }
    }];
}

- (void)finishPay {
    //已完成付款
    [self.mainViewModel fetchOrderFinishPayWithResult:^(BOOL success) {
        if (success) {
            [self fetchOrderDetailData];
        }
    }];
}

#pragma mark - FiatOrderDetailMainViewDelegate
- (void)tableViewCancelOrder:(UITableView *)tableView {
    //取消订单
    [self cancelOrderTip];
}

- (void)tableViewFinishPay:(UITableView *)tableView {
    //已完成付款
    [self finishPay];
}

- (void)tableViewAppeal:(UITableView *)tableView {
    //申诉
    AppealViewController *appealVC = [[AppealViewController alloc] init];
    appealVC.orderNo = self.orderNo;
    appealVC.orderType = self.mainViewModel.orderDetailModel.pageType;
    [self.navigationController pushViewController:appealVC animated:YES];
}

- (void)tableView:(UITableView *)tableView putMoneyWithPassword:(NSString *)password {
    //放币
    [self.mainViewModel fetchPutMoneyWithPassword:password result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"操作成功", nil) completionHandle:^{
                [self popViewController];
            }];
        }
    }];
}

- (void)tableViewWithForgetPassword:(UITableView *)tableView {
    //忘记资金密码
    ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc] init];
    modifyPasswordVC.modifyType = ModifyTypeAssetsPassword;
    [self.navigationController pushViewController:modifyPasswordVC animated:YES];
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

#pragma mark - Setter & Getter
- (FiatOrderDetailMainView *)mainView {
    if (!_mainView) {
        _mainView = [[FiatOrderDetailMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (MarginPopupView *)cancelPopupView {
    if (!_cancelPopupView) {
        _cancelPopupView = [[MarginPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_cancelPopupView setOnBtnWithYesBlock:^{
            [weakSelf cancelOrder];
        }];
    }
    return _cancelPopupView;
}

- (FiatMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[FiatMainViewModel alloc] initWithOrderNo:self.orderNo pageType:self.pageType];
    }
    return _mainViewModel;
}

@end
