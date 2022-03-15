//
//  ModifyPasswordMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ModifyPasswordMainView.h"
#import "SafetyVerificationView.h"

#import "UserInfoManager.h"
#import "HomeMainViewModel.h"

@interface ModifyPasswordMainView ()
@property (nonatomic, strong) UITextField *tfOldPassword;
@property (nonatomic, strong) UITextField *tfNewPassword;
@property (nonatomic, strong) UITextField *tfConfirmPassword;

@property (nonatomic, strong) UILabel *lbTipTop;
@property (nonatomic, strong) UILabel *lbOldTitle;
@property (nonatomic, strong) UILabel *lbNewTitle;
@property (nonatomic, strong) UILabel *lbConfirmTitle;

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *lbTip;

@property (nonatomic, strong) SafetyVerificationView *safetyView;

@end

@implementation ModifyPasswordMainView
#pragma mark - Event Response
- (void)onBtnWithSeePasswordEvent:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.tag == 101) {
        self.tfOldPassword.secureTextEntry = !btn.selected;
    } else if (btn.tag == 102) {
        self.tfNewPassword.secureTextEntry = !btn.selected;
    } else {
        self.tfConfirmPassword.secureTextEntry = !btn.selected;
    }
}

- (void)onBtnWithSubmitEvent:(UIButton *)btn {
    //提交
    ModifyType modifyType = [(HomeMainViewModel *)self.mainViewModel modifyType];
    if (modifyType == ModifyTypeLoginPassword) {
        //登录密码
        if ([NSString isEmpty:self.tfOldPassword.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入旧密码", nil) duration:2];
        }
        if ([NSString isEmpty:self.tfNewPassword.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入新密码", nil) duration:2];
        }
        if (self.tfNewPassword.text.length < 6 || self.tfNewPassword.text.length > 18) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请设置6-18位登录密码", nil) duration:2];
        }
        if ([NSString isEmpty:self.tfConfirmPassword.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请确认您的新密码", nil) duration:2];
        }
        if (![self.tfNewPassword.text isEqualToString:self.tfConfirmPassword.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"密码不一致", nil) duration:2];
        }
        [(HomeMainViewModel *)self.mainViewModel setPassword:self.tfNewPassword.text];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithUpdateNewPassword:)]) {
            [self.delegate performSelector:@selector(mainViewWithUpdateNewPassword:) withObject:self.tfOldPassword.text];
        }
    } else if (modifyType == ModifyTypeAssetsPassword) {
        //资产密码
        if ([NSString isEmpty:self.tfOldPassword.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入资产密码", nil) duration:2];
        }
        if (self.tfOldPassword.text.length != 6) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入6位纯数字密码", nil) duration:2];
        }
        if ([NSString isEmpty:self.tfNewPassword.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请确认您的资产密码", nil) duration:2];
        }
        if (![self.tfOldPassword.text isEqualToString:self.tfNewPassword.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"密码不一致", nil) duration:2];
        }
        [(HomeMainViewModel *)self.mainViewModel setPassword:self.tfOldPassword.text];
        //停止倒计时
        [(HomeMainViewModel *)self.mainViewModel stopCountDown];
        if ([[UserInfoManager sharedManager].paySmsType isEqualToString:@"EMAIL"]) {
            //邮箱发送验证码
            [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypeEmail];
        } else {
            //手机发送验证码
            [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypePhone];
        }
    } else if (modifyType == ModifyTypeNickName) {
        //法币交易昵称
        if ([NSString isEmpty:self.tfOldPassword.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入您的个性昵称", nil) duration:2];
        }
        if (self.tfOldPassword.text.length < 4 || self.tfOldPassword.text.length > 10) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"昵称为4-10位数字、字母或汉字", nil) duration:2];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithSetNickName:)]) {
            [self.delegate performSelector:@selector(mainViewWithSetNickName:) withObject:self.tfOldPassword.text];
        }
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.lbTipTop = [UILabel labelWithText:NSLocalizedString(@"修改密码后，24小时内无法提币", nil) textColor:[UIColor whiteColor] font:kFont(12)];
    self.lbTipTop.backgroundColor = kRGB(205, 61, 88);
    self.lbTipTop.textAlignment = NSTextAlignmentCenter;
    self.lbTipTop.hidden = YES;
    [self addSubview:self.lbTipTop];
    [self.lbTipTop makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(29);
    }];
    
    self.lbOldTitle = [UILabel labelWithText:NSLocalizedString(@"旧密码", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:self.lbOldTitle];
    [self.lbOldTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 20);
        make.left.equalTo(15);
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *btnSee = [UIButton buttonWithImageName:@"unseen" highlightedImageName:@"unseen" target:self selector:@selector(onBtnWithSeePasswordEvent:)];
    [btnSee setImage:[UIImage imageNamed:@"seen"] forState:UIControlStateSelected];
    btnSee.frame = CGRectMake(0, 0, 40, 40);
    btnSee.tag = 101;
    [rightView addSubview:btnSee];
    
    self.tfOldPassword = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入旧密码", nil) hasLine:YES];
    self.tfOldPassword.keyboardType = UIKeyboardTypeAlphabet;
    self.tfOldPassword.rightView = rightView;
    self.tfOldPassword.rightViewMode = UITextFieldViewModeAlways;
    self.tfOldPassword.secureTextEntry = YES;
    [self addSubview:self.tfOldPassword];
    [self.tfOldPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbOldTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    self.lbNewTitle = [UILabel labelWithText:NSLocalizedString(@"新密码", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    self.lbNewTitle.hidden = YES;
    [self addSubview:self.lbNewTitle];
    [self.lbNewTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfOldPassword.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    UIView *rightViewNew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *btnSeeNew = [UIButton buttonWithImageName:@"unseen" highlightedImageName:@"unseen" target:self selector:@selector(onBtnWithSeePasswordEvent:)];
    [btnSeeNew setImage:[UIImage imageNamed:@"seen"] forState:UIControlStateSelected];
    btnSeeNew.frame = CGRectMake(0, 0, 40, 40);
    btnSeeNew.tag = 102;
    [rightViewNew addSubview:btnSeeNew];
    
    self.tfNewPassword = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入新密码", nil) hasLine:YES];
    self.tfNewPassword.keyboardType = UIKeyboardTypeAlphabet;
    self.tfNewPassword.rightView = rightViewNew;
    self.tfNewPassword.rightViewMode = UITextFieldViewModeAlways;
    self.tfNewPassword.secureTextEntry = YES;
    self.tfNewPassword.hidden = YES;
    [self addSubview:self.tfNewPassword];
    [self.tfNewPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbNewTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    self.lbConfirmTitle = [UILabel labelWithText:NSLocalizedString(@"确认密码", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    self.lbConfirmTitle.hidden = YES;
    [self addSubview:self.lbConfirmTitle];
    [self.lbConfirmTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfNewPassword.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    UIView *rightViewConfirm = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *btnSeeConfirm = [UIButton buttonWithImageName:@"unseen" highlightedImageName:@"unseen" target:self selector:@selector(onBtnWithSeePasswordEvent:)];
    [btnSeeConfirm setImage:[UIImage imageNamed:@"seen"] forState:UIControlStateSelected];
    btnSeeConfirm.frame = CGRectMake(0, 0, 40, 40);
    btnSeeConfirm.tag = 103;
    [rightViewConfirm addSubview:btnSeeConfirm];
    
    self.tfConfirmPassword = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入您的密码", nil) hasLine:YES];
    self.tfConfirmPassword.keyboardType = UIKeyboardTypeAlphabet;
    self.tfConfirmPassword.rightView = rightViewConfirm;
    self.tfConfirmPassword.rightViewMode = UITextFieldViewModeAlways;
    self.tfConfirmPassword.secureTextEntry = YES;
    self.tfConfirmPassword.hidden = YES;
    [self addSubview:self.tfConfirmPassword];
    [self.tfConfirmPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbConfirmTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UIButton *btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"提交", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSubmitEvent:)];
    btnSubmit.backgroundColor = kRGB(0, 102, 237);
    btnSubmit.layer.cornerRadius = 4;
    [self addSubview:btnSubmit];
    [btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfOldPassword.mas_bottom).offset(232);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    [self addSubview:self.tipView];
    [self.tipView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfOldPassword.mas_bottom).offset(0);
        make.left.right.equalTo(0);
        make.height.equalTo(145);
    }];
}

- (void)updateView {
    ModifyType modifyType = [(HomeMainViewModel *)self.mainViewModel modifyType];
    if (modifyType == ModifyTypeNickName) {
        //法币交易昵称
        self.lbOldTitle.text = NSLocalizedString(@"昵称", nil);
        self.tfOldPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入您的个性昵称", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfOldPassword.secureTextEntry = NO;
        self.tfOldPassword.rightViewMode = UITextFieldViewModeNever;
        self.tfOldPassword.keyboardType = UIKeyboardTypeDefault;
        self.tipView.hidden = NO;
        self.lbTip.text = NSLocalizedString(@"昵称为4-10位数字、字母或汉字", nil);
        [self.tipView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tfOldPassword.mas_bottom).offset(0);
        }];
        
        self.tfOldPassword.text = [UserInfoManager sharedManager].nickName;
    } else if (modifyType == ModifyTypeAssetsPassword) {
        //资产密码
        self.lbOldTitle.text = NSLocalizedString(@"资产密码", nil);
        self.tfOldPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入资产密码", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.lbNewTitle.hidden = NO;
        self.tfNewPassword.hidden = NO;
        self.lbNewTitle.text = NSLocalizedString(@"确认密码", nil);
        self.tfNewPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请确认您的资产密码", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfOldPassword.rightViewMode = UITextFieldViewModeNever;
        self.tfNewPassword.rightViewMode = UITextFieldViewModeNever;
        self.tfOldPassword.keyboardType = UIKeyboardTypeNumberPad;
        self.tfNewPassword.keyboardType = UIKeyboardTypeNumberPad;
        self.tipView.hidden = NO;
        self.lbTip.text = NSLocalizedString(@"资产密码为6位纯数字组成，供账户内资产变更时使用，请您妥善保管，避免造成您账户资产损失", nil);
        [self.tipView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tfOldPassword.mas_bottom).offset(77);
        }];
    } else if (modifyType == ModifyTypeLoginPassword) {
        //登录密码
        self.tipView.hidden = YES;
        self.lbTipTop.hidden = NO;
        self.lbNewTitle.hidden = NO;
        self.tfNewPassword.hidden = NO;
        self.lbConfirmTitle.hidden = NO;
        self.tfConfirmPassword.hidden = NO;
        [self.lbOldTitle updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kNavBarHeight + 49);
        }];
    }
}

- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd {
    [self.safetyView updateCountDown:countDown isEnd:isEnd];
}

#pragma mark - Setter & Getter
- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 155)];
        _tipView.hidden = NO;
        _tipView.backgroundColor = [UIColor clearColor];
        UIImageView *imgViewTip = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"wxts"]];
        [_tipView addSubview:imgViewTip];
        [imgViewTip makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(20);
            make.top.equalTo(40);
            make.left.equalTo(15);
        }];
        
        UILabel *lbTipTitle = [UILabel labelWithText:NSLocalizedString(@"温馨提示：", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
        [_tipView addSubview:lbTipTitle];
        [lbTipTitle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgViewTip.mas_right).offset(10);
            make.centerY.equalTo(imgViewTip);
        }];
        
        self.lbTip = [UILabel labelWithText:@"" textColor:kRGB(153, 153, 153) font:kFont(12)];
        self.lbTip.numberOfLines = 0;
        [_tipView addSubview:self.lbTip];
        [self.lbTip makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgViewTip.mas_bottom).offset(10);
            make.left.equalTo(15);
            make.right.equalTo(-15);
        }];
    }
    return _tipView;
}

- (SafetyVerificationView *)safetyView {
    if (!_safetyView) {
        _safetyView = [[SafetyVerificationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_safetyView setOnBtnWithSendVerifyCodeBlock:^{
            //获取验证码
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithSendVerifyCode)]) {
                [weakSelf.delegate performSelector:@selector(mainViewWithSendVerifyCode)];
            }
        }];
        [_safetyView setOnBtnWithSubmitRegisterBlock:^(NSString * _Nonnull verifyCode) {
            //设置密码
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithUpdateNewPassword:)]) {
                [weakSelf.delegate performSelector:@selector(mainViewWithUpdateNewPassword:) withObject:verifyCode];
            }
        }];
    }
    return _safetyView;
}

@end
