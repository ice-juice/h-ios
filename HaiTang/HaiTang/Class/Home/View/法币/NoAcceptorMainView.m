//
//  NoAcceptorMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NoAcceptorMainView.h"
#import "EnterFundPasswordView.h"

#import "AcceptorModel.h"
#import "FiatMainViewModel.h"

@interface NoAcceptorMainView ()
@property (nonatomic, strong) UILabel *lbMargin;
@property (nonatomic, strong) UILabel *lbAvailable;
@property (nonatomic, strong) UIButton *btnSubmit;

@property (nonatomic, strong) EnterFundPasswordView *passwordView;

@end

@implementation NoAcceptorMainView
#pragma mark - Event Response
- (void)onBtnWithBecomeAcceptorEvent:(UIButton *)btn {
    //成为承兑商
    [self.passwordView showViewWithTitle:@"缴费确认"];
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"fbjy-cds-k"]];
    [self addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 40);
        make.centerX.equalTo(0);
        make.width.height.equalTo(CGSizeMake(133, 100));
    }];
    
    UILabel *lbIdentity = [UILabel labelWithText:NSLocalizedString(@"您当前不是承兑商身份", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbIdentity];
    [lbIdentity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(15);
        make.centerX.equalTo(0);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4;
    [self addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbIdentity.mas_bottom).offset(60);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(185);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"缴纳保证金", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.centerX.equalTo(0);
    }];
    
    self.lbMargin = [UILabel labelWithText:@"" textColor:kRedColor font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
    [contentView addSubview:self.lbMargin];
    [self.lbMargin makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(5);
        make.centerX.equalTo(0);
    }];
    
    self.lbAvailable = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [contentView addSubview:self.lbAvailable];
    [self.lbAvailable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbMargin.mas_bottom).offset(25);
        make.left.equalTo(35);
    }];
    
    self.btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"缴纳并申请成为承兑商", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithBecomeAcceptorEvent:)];
    self.btnSubmit.backgroundColor = kRGB(0, 102, 237);
    self.btnSubmit.layer.cornerRadius = 4;
    [contentView addSubview:self.btnSubmit];
    [self.btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-21);
        make.left.equalTo(35);
        make.right.equalTo(-35);
        make.height.equalTo(30);
    }];
    
    UIImageView *imgViewTip = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"wxts"]];
    [self addSubview:imgViewTip];
    [imgViewTip makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(20);
        make.top.equalTo(contentView.mas_bottom).offset(40);
        make.left.equalTo(15);
    }];
    
    UILabel *lbTipTitle = [UILabel labelWithText:NSLocalizedString(@"温馨提示：", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbTipTitle];
    [lbTipTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgViewTip);
        make.left.equalTo(imgViewTip.mas_right).offset(10);
    }];
    
    UILabel *lbTip = [UILabel labelWithText:NSLocalizedString(@"如审核未通过，您缴纳的保证金将返回至您USDT法币资产账户", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
    lbTip.numberOfLines = 0;
    [self addSubview:lbTip];
    [lbTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(imgViewTip.mas_bottom).offset(10);
        make.right.equalTo(-10);
    }];
}

- (void)updateView {
    AcceptorModel *acceptModel = [(FiatMainViewModel *)self.mainViewModel acceptorModel];
    self.lbMargin.text = [NSString stringWithFormat:@"%.4f USDT", acceptModel.USDT.floatValue];
    self.lbAvailable.text = [NSString stringWithFormat:@"%@：%.8f", NSLocalizedString(@"USDT法币账户可用资产", nil), [acceptModel.usedPrice floatValue]];
    if ([acceptModel.deposit isEqualToString:@"6"]) {
        //承兑商申请审核中
        self.btnSubmit.userInteractionEnabled = NO;
    } else {
        self.btnSubmit.userInteractionEnabled = YES;
    }
}

#pragma mark - Setter & Getter
- (EnterFundPasswordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[EnterFundPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_passwordView setOnBtnSubmitPasswordBlock:^(NSString * _Nonnull password) {
            [(FiatMainViewModel *)weakSelf.mainViewModel setPayPwd:password];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(applyToBecomeAnAcceptor)]) {
                [weakSelf.delegate performSelector:@selector(applyToBecomeAnAcceptor)];
            }
        }];
        [_passwordView setOnBtnForgetPasswordBlock:^{
            //忘记密码
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onForgetAssetsPassword)]) {
                [weakSelf.delegate performSelector:@selector(onForgetAssetsPassword)];
            }
        }];
    }
    return _passwordView;
}

@end
