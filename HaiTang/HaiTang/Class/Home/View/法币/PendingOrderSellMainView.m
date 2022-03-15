//
//  PendingOrderSellMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PendingOrderSellMainView.h"
#import "PendingOrderSellTableCell.h"
#import "ChooseAccountPopupView.h"
#import "EnterFundPasswordView.h"

#import "NewModel.h"
#import "OrderModel.h"
#import "BaseTableModel.h"
#import "FiatMainViewModel.h"

@interface PendingOrderSellMainView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *tfPrice;          //出售单价
@property (nonatomic, strong) UITextField *tfNumber;         //出售数量
@property (nonatomic, strong) UITextField *tfMinNumber;      //单笔最小出售数量
@property (nonatomic, strong) UITextField *tfMinAmount;      //单笔最小出售金额
@property (nonatomic, strong) UILabel *lbAvailable;          //可用
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ChooseAccountPopupView *chooseAccountView;
@property (nonatomic, strong) EnterFundPasswordView *passwordView;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) OrderModel *orderModel;
//选中的账号model
@property (nonatomic, strong) NewModel *selectModel;

@end

@implementation PendingOrderSellMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(FiatMainViewModel *)self.mainViewModel arrayPaymentTableDatas] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PendingOrderSellTableCell *cell = [PendingOrderSellTableCell cellWithTableNibView:tableView];
    if (indexPath.row < [[(FiatMainViewModel *)self.mainViewModel arrayPaymentTableDatas] count]) {
        BaseTableModel *tableModel = [(FiatMainViewModel *)self.mainViewModel arrayPaymentTableDatas][indexPath.row];
        [cell setViewWithModel:tableModel];
        if (indexPath.row == self.selectIndex) {
            cell.isCellSelected = YES;
            cell.selectModel = self.selectModel;
        } else {
            cell.isCellSelected = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [[(FiatMainViewModel *)self.mainViewModel arrayPaymentTableDatas] count]) {
        self.selectIndex = indexPath.row;
        [tableView reloadData];
        
        BaseTableModel *tableModel = [(FiatMainViewModel *)self.mainViewModel arrayPaymentTableDatas][indexPath.row];
        if (tableModel.content && [tableModel.content count]) {
            [self.chooseAccountView setViewWithModel:tableModel.content];
        } else {
            //前往绑定收款方式
            if (self.delegate && [self.delegate respondsToSelector:@selector(addPaymentWithIndexPath:)]) {
                [self.delegate performSelector:@selector(addPaymentWithIndexPath:) withObject:indexPath];
            }
        }
    }
}

#pragma mark - Event Response
- (void)onBtnWithAllEvent:(UIButton *)btn {
    self.tfNumber.text = self.orderModel.price;
}

- (void)onBtnWithSubmitEvent:(UIButton *)btn {
    //提交下单
    if ([NSString isEmpty:self.tfPrice.text] || [self.tfPrice.text isEqualToString:@"0"]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入出售单价", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfNumber.text] || [self.tfNumber.text isEqualToString:@"0"]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入出售数量", nil) duration:2];
    }
    
    if ([NSString isEmpty:self.tfMinNumber.text] || [self.tfMinNumber.text isEqualToString:@"0"]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入最小出售数量", nil) duration:2];
    }
    
    if ([NSString isEmpty:self.tfMinAmount.text] || [self.tfMinAmount.text isEqualToString:@"0"]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入最小出售金额", nil) duration:2];
    }
    if (self.selectModel == nil) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请选择收款方式", nil) duration:2];
    }
    
    [(FiatMainViewModel *)self.mainViewModel setPrice:self.tfPrice.text];
    [(FiatMainViewModel *)self.mainViewModel setNumber:self.tfNumber.text];
    [(FiatMainViewModel *)self.mainViewModel setLowNumber:self.tfMinNumber.text];
    [(FiatMainViewModel *)self.mainViewModel setLowPrice:self.tfMinAmount.text];
    [(FiatMainViewModel *)self.mainViewModel setPayMethod:self.selectModel.type];
    [(FiatMainViewModel *)self.mainViewModel setPaymentId:self.selectModel.paymentId];
    if ([self.orderModel.realStatus isEqualToString:@"1"]) {
        //实名认证
//        [self.passwordView showViewWithTitle:@"挂单出售确认"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(submitPendingOrderSell)]) {
            [self.delegate performSelector:@selector(submitPendingOrderSell)];
        }
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(kScreenWidth, 850);
    [self addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 850)];
    [scrollView addSubview:contentView];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = kRGB(248, 248, 248);
    [contentView addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(40);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"出售币种", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [topView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(15);
    }];
    
    UILabel *lbUsdt = [UILabel labelWithText:@"USDT" textColor:kRGB(0, 102, 237) font:kBoldFont(14)];
    [topView addSubview:lbUsdt];
    [lbUsdt makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(-15);
    }];
    
    UIView *priceView = [self createViewWithTitle:@"出售单价" rightViewText:@"USD" index:0];
    [contentView addSubview:priceView];
    [priceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    
    UIView *numerView = [self createViewWithTitle:@"出售数量" rightViewText:@"USDT" index:1];
    [contentView addSubview:numerView];
    [numerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    
    UILabel *lbAvailableTitle = [UILabel labelWithText:NSLocalizedString(@"可用：", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
    [contentView addSubview:lbAvailableTitle];
    [lbAvailableTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numerView.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbAvailable = [UILabel labelWithText:@"0.00 USDT" textColor:kRedColor font:kFont(12)];
    [contentView addSubview:self.lbAvailable];
    [self.lbAvailable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbAvailableTitle);
        make.right.equalTo(-15);
    }];
    
    UIView *minNumerView = [self createViewWithTitle:@"单笔最小出售数量" rightViewText:@"USDT" index:2];
    [contentView addSubview:minNumerView];
    [minNumerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbAvailableTitle.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    
    UIView *minAmountView = [self createViewWithTitle:@"单笔最小出售金额" rightViewText:@"USD" index:3];
    [contentView addSubview:minAmountView];
    [minAmountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minNumerView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    
    UILabel *lbPayment = [UILabel labelWithText:NSLocalizedString(@"选择付款方式", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [contentView addSubview:lbPayment];
    [lbPayment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minAmountView.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    [contentView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbPayment.mas_bottom).offset(15);
        make.left.right.equalTo(0);
        make.height.equalTo(176);
    }];
    
    UIButton *btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"提交下单", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSubmitEvent:)];
    btnSubmit.backgroundColor = kRGB(0, 102, 237);
    btnSubmit.layer.cornerRadius = 4;
    [contentView addSubview:btnSubmit];
    [btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    self.selectModel = nil;
    self.selectIndex = 0;
}

- (void)updateView {
    self.tfPrice.text = @"";
    self.tfNumber.text = @"";
    self.tfMinNumber.text = @"";
    self.tfMinAmount.text = @"";
    
    self.orderModel = [(FiatMainViewModel *)self.mainViewModel orderDetailModel];
    self.lbAvailable.text = [NSString stringWithFormat:@"%.2fUSDT", [self.orderModel.price floatValue]];
    BaseTableModel *tableModel = [(FiatMainViewModel *)self.mainViewModel arrayPaymentTableDatas][self.selectIndex];
    if (tableModel.content && [tableModel.content count]) {
        self.selectModel = tableModel.content[0];
    } else {
        self.selectModel = nil;
    }
    
    [self.tableView reloadData];
}

- (UIView *)createViewWithTitle:(NSString *)title rightViewText:(NSString *)rightViewText index:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(title, nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [view addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 40)];
    
    UIButton *btnAll = [UIButton buttonWithTitle:NSLocalizedString(@"全部  |", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnWithAllEvent:)];
    btnAll.frame = CGRectMake(0, 0, 52, 40);
    btnAll.hidden = YES;
    [rightView addSubview:btnAll];
    btnAll.titleLabel.attributedText = [btnAll.titleLabel.text attributedStringWithSubString:@"|" subColor:kRGB(16, 16, 16)];
    
    UILabel *lbRight = [UILabel labelWithText:rightViewText textColor:kRGB(16, 16, 16) font:kFont(14)];
    lbRight.frame = CGRectMake(62, 10, 40, 20);
    lbRight.textAlignment = NSTextAlignmentRight;
    [rightView addSubview:lbRight];
    
    UITextField *textField = [[UITextField alloc] initNoLeftViewWithPlaceHolder:@"0.00" hasLine:YES];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [view addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    if (index == 0) {
        //出售单价
        self.tfPrice = textField;
    } else if (index == 1) {
        //出售数量
        self.tfNumber = textField;
        btnAll.hidden = NO;
    } else if (index == 2) {
        //最小出售数量
        self.tfMinNumber = textField;
    } else {
        //最小出售金额
        self.tfMinAmount = textField;
    }
    
    return view;
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (ChooseAccountPopupView *)chooseAccountView {
    if (!_chooseAccountView) {
        _chooseAccountView = [[ChooseAccountPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_chooseAccountView setDidSelectAccountAtIndexBlock:^(NewModel * _Nonnull newModel) {
            //选择账号
            weakSelf.selectModel = newModel;
            [weakSelf.tableView reloadData];
        }];
    }
    return _chooseAccountView;
}

- (EnterFundPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[EnterFundPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_passwordView setOnBtnSubmitPasswordBlock:^(NSString * _Nonnull password) {
            //挂单出售
            [(FiatMainViewModel *)weakSelf.mainViewModel setPayPwd:password];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(submitPendingOrderSell)]) {
                [weakSelf.delegate performSelector:@selector(submitPendingOrderSell)];
            }
        }];
    }
    return _passwordView;
}

@end
