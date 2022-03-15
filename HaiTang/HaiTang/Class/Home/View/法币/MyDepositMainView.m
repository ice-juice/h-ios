//
//  MyDepositMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "MyDepositMainView.h"
#import "MarginPopupView.h"
#import "EnterFundPasswordView.h"

#import "AcceptorModel.h"
#import "FiatMainViewModel.h"

@interface MyDepositMainView ()
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbAmount;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIButton *btnReturn;

@property (nonatomic, strong) MarginPopupView *marginView;
@property (nonatomic, strong) EnterFundPasswordView *passwordView;

@end

@implementation MyDepositMainView
#pragma mark - Event Response
- (void)onBtnWithReturnMoneyEvent:(UIButton *)btn {
    //退还保证金
    [self.marginView showViewWithPopupType:PopupTypeReturn];
}

- (void)onBtnWithRefundRemainingMoneyEvent:(UIButton *)btn {
    //退还剩余保证金
    [self.marginView showViewWithPopupType:PopupTypeReturn];
}

- (void)onBtnWithPayBackEvent:(UIButton *)btn {
    //补缴保证金
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPayBack)]) {
        [self.delegate performSelector:@selector(onPayBack)];
    }
}

- (void)onBtnMakeUpEvent:(UIButton *)btn {
    //确认补缴
    [self.passwordView showViewWithTitle:NSLocalizedString(@"缴费确认", nil)];
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.lbTitle = [UILabel labelWithText:NSLocalizedString(@"请您支付：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    self.lbTitle.hidden = YES;
    [self addSubview:self.lbTitle];
    [self.lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(38 + kNavBarHeight);
        make.left.equalTo(15);
    }];
    
    self.lbAmount = [UILabel labelWithText:@"" textColor:kRedColor font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
    [self addSubview:self.lbAmount];
    [self.lbAmount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 60);
        make.centerX.equalTo(0);
    }];
    
    self.btnSubmit = [UIButton buttonWithTitle:@"" titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:nil selector:nil];
    self.btnSubmit.backgroundColor = kRGB(0, 102, 237);
    self.btnSubmit.layer.cornerRadius = 4;
    [self addSubview:self.btnSubmit];
    [self.btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbAmount.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    self.btnReturn = [UIButton buttonWithTitle:nil titleColor:kRGB(153, 153, 153) highlightedTitleColor:kRGB(153, 153, 153) font:kFont(12) target:nil selector:nil];
    self.btnReturn.hidden = YES;
    [self addSubview:self.btnReturn];
    [self.btnReturn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnSubmit.mas_bottom).offset(15);
        make.centerX.equalTo(0);
    }];
}

- (void)updateView {
    AcceptorModel *acceptModel = [(FiatMainViewModel *)self.mainViewModel acceptorModel];
    
    if ([(FiatMainViewModel *)self.mainViewModel depositStatus] == MyDepositStatusMakeUp) {
        //确认补缴
        self.lbTitle.hidden = NO;
        self.lbAmount.text = [NSString stringWithFormat:@"%.2f %@", [acceptModel.number floatValue], acceptModel.coin];
        [self.btnSubmit setTitle:NSLocalizedString(@"确认补缴", nil) forState:UIControlStateNormal];
        [self.btnSubmit addTarget:self action:@selector(onBtnMakeUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        NSString *amount = [acceptModel.deposit isEqualToString:@"0"] ? acceptModel.number : acceptModel.USDT;
        self.lbAmount.text = [NSString stringWithFormat:@"%.2f USDT", [amount floatValue]];
        
        if ([acceptModel.deposit isEqualToString:@"1"]) {
            //全部缴纳
            self.lbTitle.hidden = YES;
            self.btnReturn.hidden = YES;
            [self.btnSubmit setTitle:NSLocalizedString(@"退还保证金", nil) forState:UIControlStateNormal];
            [self.btnSubmit addTarget:self action:@selector(onBtnWithReturnMoneyEvent:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([acceptModel.deposit isEqualToString:@"0"]) {
            //待补缴
            self.lbTitle.hidden = YES;
            self.btnReturn.hidden = NO;
            [self.btnSubmit setTitle:NSLocalizedString(@"补缴保证金", nil) forState:UIControlStateNormal];
            [self.btnSubmit addTarget:self action:@selector(onBtnWithPayBackEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnReturn setTitle:NSLocalizedString(@"退还剩余保证金", nil) forState:UIControlStateNormal];
            [self.btnReturn addTarget:self action:@selector(onBtnWithRefundRemainingMoneyEvent:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([acceptModel.deposit isEqualToString:@"3"]) {
            //退还中
            self.lbTitle.hidden = YES;
            self.btnReturn.hidden = YES;
            [self.btnSubmit setTitle:NSLocalizedString(@"退还中，请您耐心等待到账", nil) forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Setter & Getter
- (MarginPopupView *)marginView {
    if (!_marginView) {
        _marginView = [[MarginPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_marginView setOnBtnWithYesBlock:^{
            //退还保证金
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onRefundDeposit)]) {
                [weakSelf.delegate performSelector:@selector(onRefundDeposit)];
            }
        }];
    }
    return _marginView;
}

- (EnterFundPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[EnterFundPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_passwordView setOnBtnForgetPasswordBlock:^{
            //忘记资金密码
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onForgetPassword)]) {
                [weakSelf.delegate performSelector:@selector(onForgetPassword)];
            }
        }];
        [_passwordView setOnBtnSubmitPasswordBlock:^(NSString * _Nonnull password) {
            //提交
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onSubmitPayBackWithPassword:)]) {
                [weakSelf.delegate performSelector:@selector(onSubmitPayBackWithPassword:) withObject:password];
            }
        }];
    }
    return _passwordView;
}

@end
