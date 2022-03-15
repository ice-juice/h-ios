//
//  FiatMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatMainView.h"
#import "EmptyView.h"
#import "FiatTableCell.h"
#import "OrderPopupView.h"
#import "PaymentMethodView.h"
#import "FilterPurchaseView.h"
#import "EnterFundPasswordView.h"

#import "OrderModel.h"
#import "UserInfoManager.h"
#import "FiatMainViewModel.h"

@interface FiatMainView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) FilterPurchaseView *filterView;
@property (nonatomic, strong) OrderPopupView *orderPopupView;
@property (nonatomic, strong) PaymentMethodView *methodView;
@property (nonatomic, strong) EnterFundPasswordView *passwordView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;

@end

@implementation FiatMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FiatTableCell *cell = [FiatTableCell cellWithTableNibView:tableView];
    if (indexPath.section < [[(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas] count]) {
        OrderModel *orderModel = [(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas][indexPath.section];
        WeakSelf
        [cell setOnBtnWithPlaceOnOrderBlock:^(OrderModel * _Nonnull orderModel) {
            //下单
            [weakSelf.orderPopupView setViewWithModel:orderModel];
        }];
        [cell setViewWithModel:orderModel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark - Event Response
- (void)onBtnWithSwitchMethodEvent:(UIButton *)btn {
    //我要购买、出售
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 100;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = YES;
            obj.titleLabel.font = kBoldFont(20);
        } else {
            obj.selected = NO;
            obj.titleLabel.font = kFont(16);
        }
    }];
    [(FiatMainViewModel *)self.mainViewModel setOrderType:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithCheckFiatOrder:)]) {
        [self.delegate performSelector:@selector(tableViewWithCheckFiatOrder:) withObject:self.tableView];
    }
}

- (void)onBtnWithFilterEvent:(UIButton *)btn {
    //筛选
    [self.filterView showView];
}

- (void)onBtnWithOrderEvent:(UIButton *)btn {
    //我的订单
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithCheckMineOrder:)]) {
        [self.delegate performSelector:@selector(tableViewWithCheckMineOrder:) withObject:self.tableView];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    [self addSubview:self.headView];
    [self.headView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(103);
    }];
    
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped shouldRefresh:YES];
    self.tableView.rowHeight = 145;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 103);
    }];
    
    self.emptyView = [[EmptyView alloc] initWithSuperView:self.tableView title:nil imageName:@"fbjy-cds-k"];
}

- (void)updateView {
    self.emptyView.hidden = [[(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas] count];
    [self.methodView setViewWithModel:[(FiatMainViewModel *)self.mainViewModel arrayPaymentMethodDatas]];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - Setter & Getter
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectZero];
        _headView.backgroundColor = [UIColor whiteColor];
        
        if (self.arrayBtns) {
            [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self.arrayBtns removeAllObjects];
        }
        [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(153, 153, 153) highlightedTitleColor:kRGB(153, 153, 153) font:kFont(16) target:self selector:@selector(onBtnWithSwitchMethodEvent:)];
            [btn setTitleColor:kRGB(16, 16, 16) forState:UIControlStateSelected];
            btn.tag = idx + 100;
            [_headView addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(20);
                make.left.equalTo(15 + 82 * idx);
                make.width.equalTo(82);
                make.height.equalTo(30);
            }];
            [self.arrayBtns addObject:btn];
            if (idx == 0) {
                btn.selected = YES;
                btn.titleLabel.font = kBoldFont(20);
            }
        }];
        
        UIButton *btnOrder = [UIButton buttonWithTitle:NSLocalizedString(@"订单", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(8) target:self selector:@selector(onBtnWithOrderEvent:)];
        [btnOrder setImage:[StatusHelper imageNamed:@"fbjy-dd"] forState:UIControlStateNormal];
        [_headView addSubview:btnOrder];
        [btnOrder makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(30);
            make.right.equalTo(-15);
            make.top.equalTo(23);
        }];
        [btnOrder setTitleDownSpace:5];
        
        UIButton *btnFilter = [UIButton buttonWithTitle:NSLocalizedString(@"筛选", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(8) target:self selector:@selector(onBtnWithFilterEvent:)];
        [btnFilter setImage:[StatusHelper imageNamed:@"fbjy-sx"] forState:UIControlStateNormal];
        [_headView addSubview:btnFilter];
        [btnFilter makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(40);
            make.right.equalTo(btnOrder.mas_left).offset(-10);
            make.centerY.equalTo(btnOrder);
        }];
        [btnFilter setTitleDownSpace:5];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kRGB(236, 236, 236);
        [_headView addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.height.equalTo(0.5);
            make.top.equalTo(63);
        }];
        
        UILabel *lbUSDT = [UILabel labelWithText:@"USDT" textColor:kRGB(0, 102, 237) font:kBoldFont(14)];
        [_headView addSubview:lbUSDT];
        [lbUSDT makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).offset(10);
            make.left.equalTo(15);
        }];
    }
    
    return _headView;
}

- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayBtns;
}

- (NSArray<NSString *> *)arrayBtnTitles {
    if (!_arrayBtnTitles) {
        _arrayBtnTitles = @[@"我要购买", @"我要出售"];
    }
    return _arrayBtnTitles;
}

- (FilterPurchaseView *)filterView {
    if (!_filterView) {
        _filterView = [[FilterPurchaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_filterView setOnBtnWithFilterBlock:^(NSString * _Nonnull payment, NSString * _Nonnull price, NSString * _Nonnull number) {
            [(FiatMainViewModel *)weakSelf.mainViewModel setPayMethod:payment];
            [(FiatMainViewModel *)weakSelf.mainViewModel setPrice:price];
            [(FiatMainViewModel *)weakSelf.mainViewModel setNumber:number];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithCheckFiatOrder:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithCheckFiatOrder:) withObject:weakSelf.tableView];
            }
        }];
    }
    return _filterView;
}

- (OrderPopupView *)orderPopupView {
    if (!_orderPopupView) {
        _orderPopupView = [[OrderPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_orderPopupView setOnBtnWithOrderBuyBlock:^(NSString * _Nonnull orderId, NSString * _Nonnull value, NSInteger type) {
            //下单购买
            [(FiatMainViewModel *)weakSelf.mainViewModel setValue:value];
            [(FiatMainViewModel *)weakSelf.mainViewModel setBuyMethod:[NSString stringWithFormat:@"%ld", type]];
            [(FiatMainViewModel *)weakSelf.mainViewModel setSellId:orderId];
//            if ([[UserInfoManager sharedManager].realStatus isEqualToString:@"1"]) {
//                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithOrderBuy:)]) {
//                    [weakSelf.delegate performSelector:@selector(tableViewWithOrderBuy:) withObject:weakSelf.tableView];
//                }
//            } else {
//                [JYToastUtils showWithStatus:NSLocalizedString(@"未实名认证", nil) duration:2];
//            }
            //2020-02-04 添加下单购买输入密码
            [weakSelf.passwordView showViewWithTitle:NSLocalizedString(@"下单购买确认", nil)];
        }];
        [_orderPopupView setOnBtnWithOrderSellBlock:^(NSString * _Nonnull buyId, NSString * _Nonnull value, NSInteger type) {
            //下单出售
            [(FiatMainViewModel *)weakSelf.mainViewModel setValue:value];
            [(FiatMainViewModel *)weakSelf.mainViewModel setBuyMethod:[NSString stringWithFormat:@"%ld", type]];
            [(FiatMainViewModel *)weakSelf.mainViewModel setBuyId:buyId];
            weakSelf.methodView.paymentMethod = weakSelf.orderPopupView.paymentMethod;
            [weakSelf.methodView showView];
        }];
    }
    return _orderPopupView;
}

- (PaymentMethodView *)methodView {
    if (!_methodView) {
        _methodView = [[PaymentMethodView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_methodView setDidSelectPaymentAccountBlock:^(NSString * _Nonnull paymentId) {
            //选择收款账号
            [(FiatMainViewModel *)weakSelf.mainViewModel setPaymentId:paymentId];
            [weakSelf.passwordView showViewWithTitle:NSLocalizedString(@"下单出售确认", nil)];
        }];
    }
    return _methodView;
}

- (EnterFundPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[EnterFundPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_passwordView setOnBtnSubmitPasswordBlock:^(NSString * _Nonnull password) {
            //下单出售
            [(FiatMainViewModel *)weakSelf.mainViewModel setPayPwd:password];
            if ([[UserInfoManager sharedManager].realStatus isEqualToString:@"1"]) {
                //2020-02-04 添加下单购买输入密码
                NSInteger orderType = [(FiatMainViewModel *)weakSelf.mainViewModel orderType];
                if (orderType == 0)  {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithOrderBuy:)]) {
                        [weakSelf.delegate performSelector:@selector(tableViewWithOrderBuy:) withObject:weakSelf.tableView];
                    }
                } else {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithOrderSell:)]) {
                        [weakSelf.delegate performSelector:@selector(tableViewWithOrderSell:) withObject:weakSelf.tableView];
                    }
                }
            } else {
                [JYToastUtils showWithStatus:NSLocalizedString(@"未实名认证", nil) duration:2];
            }
        }];
        [_passwordView setOnBtnForgetPasswordBlock:^{
            //忘记密码
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithForgetPassword:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithForgetPassword:) withObject:weakSelf.tableView];
            }
        }];
    }
    return _passwordView;
}

@end
