//
//  FiatOrderDetailMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderDetailMainView.h"
#import "FiatOrderDetailTableCell.h"
#import "AppealDetailView.h"
#import "QRCodeImageView.h"
#import "EnterFundPasswordView.h"
#import "FiatOrderDetailTableHeaderView.h"
#import "FiatOrderDetailTableFooterView.h"

#import "OrderModel.h"
#import "FiatMainViewModel.h"

@interface FiatOrderDetailMainView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) FiatOrderDetailTableHeaderView *tableHeaderView;
@property (nonatomic, strong) FiatOrderDetailTableFooterView *tableFooterView;
@property (nonatomic, strong) AppealDetailView *appealDetailView;
@property (nonatomic, strong) QRCodeImageView *qrCodeImageView;
@property (nonatomic, strong) EnterFundPasswordView *passwordView;

@property (nonatomic, strong) UILabel *lbTip;
@property (nonatomic, strong) UIButton *btnAppeal;
@property (nonatomic, strong) UIButton *btnCancelOrder;
@property (nonatomic, strong) UIButton *btnFinish;
//倒计时未结束
@property (nonatomic, assign) BOOL isEnd;

@end

@implementation FiatOrderDetailMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FiatOrderDetailTableCell *cell = [FiatOrderDetailTableCell cellWithTableView:tableView];
    [cell setViewWithModel:[(FiatMainViewModel *)self.mainViewModel arrayOrderDetailDatas]];
    WeakSelf
    [cell setOnCheckAppealDetailBlock:^(NSString * _Nonnull type) {
        //查看申诉详情
        weakSelf.appealDetailView.type = type;
        [weakSelf.appealDetailView setViewWithModel:[(FiatMainViewModel *)weakSelf.mainViewModel orderDetailModel]];
    }];
    [cell setOnCheckQRCodeImageBlock:^{
        //查看二维码
        [weakSelf.qrCodeImageView showView:[(FiatMainViewModel *)weakSelf.mainViewModel orderDetailModel].payImg];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

#pragma mark - Event Response
- (void)onBtnWithAppealEvent:(UIButton *)btn {
    //申诉
}

- (void)onBtnWithCancelOrderEvent:(UIButton *)btn {
    //取消订单
}

- (void)onBtnWithPaidEvent:(UIButton *)btn {
    //已完成付款
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
    
    self.isEnd = YES;
}

- (void)updateView {
    self.tableView.rowHeight = [[(FiatMainViewModel *)self.mainViewModel arrayOrderDetailDatas] count] * 45 + 50;
    
    [self.tableHeaderView setViewWithModel:[(FiatMainViewModel *)self.mainViewModel orderDetailModel]];
    [self.tableFooterView setViewWithModel:[(FiatMainViewModel *)self.mainViewModel orderDetailModel]];
    if ([[(FiatMainViewModel *)self.mainViewModel orderDetailModel].status isEqualToString:@"WAIT"]) {
        //待付款、待收款
        WeakSelf
        [(FiatMainViewModel *)self.mainViewModel setOnUpdatePayCountDownBlock:^(NSString * _Nonnull timeString, BOOL isEnd) {
            //刷新倒计时
            [weakSelf.tableHeaderView.btnCountDown setTitle:timeString forState:UIControlStateNormal];
            if (isEnd) {
                //强制取消订单
//                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewCancelOrder:)]) {
//                    [weakSelf.delegate performSelector:@selector(tableViewCancelOrder:) withObject:weakSelf.tableView];
//                }
            }
        }];
    } else if ([[(FiatMainViewModel *)self.mainViewModel orderDetailModel].status isEqualToString:@"WAIT_COIN"]) {
        //已付款、待放币
        WeakSelf
        [(FiatMainViewModel *)self.mainViewModel setOnUpdatePayCountDownBlock:^(NSString * _Nonnull timeString, BOOL isEnd) {
            //刷新倒计时
            [weakSelf.tableHeaderView.btnCountDown setTitle:timeString forState:UIControlStateNormal];
            weakSelf.isEnd = isEnd;
        }];
    }
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - Setter & Getter
- (FiatOrderDetailTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[FiatOrderDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 215)];
    }
    return _tableHeaderView;
}

- (FiatOrderDetailTableFooterView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[FiatOrderDetailTableFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 164)];
        WeakSelf
        [_tableFooterView setOnBtnWithFinishPayBlock:^{
            //已完成付款
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewFinishPay:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewFinishPay:) withObject:weakSelf.tableView];
            }
        }];
        [_tableFooterView setOnBtnWithCancelOrderBlock:^{
            //取消订单
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewCancelOrder:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewCancelOrder:) withObject:weakSelf.tableView];
            }
        }];
        [_tableFooterView setOnBtnWithAppealBlock:^{
            //申诉
            if (weakSelf.isEnd) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewAppeal:)]) {
                    [weakSelf.delegate performSelector:@selector(tableViewAppeal:) withObject:weakSelf.tableView];
                }
            } else {
                [JYToastUtils showWithStatus:NSLocalizedString(@"请在倒计时结束后再发起申诉", nil) duration:2];
            }
        }];
        [_tableFooterView setOnBtnWithPutMoneyBlock:^{
            //放币
            [weakSelf.passwordView showViewWithTitle:@"放币确认"];
        }];
    }
    return _tableFooterView;
}

- (AppealDetailView *)appealDetailView {
    if (!_appealDetailView) {
        _appealDetailView = [[AppealDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _appealDetailView;
}

- (QRCodeImageView *)qrCodeImageView {
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[QRCodeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _qrCodeImageView;
}

- (EnterFundPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[EnterFundPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_passwordView setOnBtnSubmitPasswordBlock:^(NSString * _Nonnull password) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableView:putMoneyWithPassword:)]) {
                [weakSelf.delegate performSelector:@selector(tableView:putMoneyWithPassword:) withObject:weakSelf.tableView withObject:password];
            }
        }];
        [_passwordView setOnBtnForgetPasswordBlock:^{
            //忘记资金密码
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithForgetPassword:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithForgetPassword:) withObject:weakSelf.tableView];
            }
        }];
    }
    return _passwordView;
}

@end
