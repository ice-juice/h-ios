//
//  ChangePasswordMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ChangePasswordMainView.h"

#import "LoginMainViewModel.h"

@interface ChangePasswordMainView ()
@property (nonatomic, strong) UITextField *tfNewPassword;
@property (nonatomic, strong) UITextField *tfConfirmPassword;

@end

@implementation ChangePasswordMainView
#pragma mark - Event Response
- (void)onBtnWithSureEvent:(UIButton *)btn {
    if ([NSString isEmpty:self.tfNewPassword.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入密码", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfConfirmPassword.text] ||
        self.tfConfirmPassword.text.length < 6 ||
        self.tfConfirmPassword.text.length > 18) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请设置6-18位新登录密码", nil) duration:2];
    }
    
    if (![self.tfNewPassword.text isEqualToString:self.tfConfirmPassword.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"前后密码不一致", nil) duration:2];
    }
    [(LoginMainViewModel *)self.mainViewModel setPassword:self.tfNewPassword.text];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithUpdatePassword)]) {
        [self.delegate performSelector:@selector(mainViewWithUpdatePassword)];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"修改密码", nil) textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
    [self addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 20);
        make.left.equalTo(15);
    }];
    
    UILabel *lbSubTitle = [UILabel labelWithText:NSLocalizedString(@"修改密码后，24小时内无法提币", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(12)];
    [self addSubview:lbSubTitle];
    [lbSubTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    UILabel *lbNewPassword = [UILabel labelWithText:NSLocalizedString(@"新密码", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbNewPassword];
    [lbNewPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbSubTitle.mas_bottom).offset(62);
        make.left.equalTo(15);
    }];
    
    self.tfNewPassword = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入新密码", nil) hasLine:YES];
    self.tfNewPassword.keyboardType = UIKeyboardTypeAlphabet;
    self.tfNewPassword.secureTextEntry = YES;
    [self addSubview:self.tfNewPassword];
    [self.tfNewPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbNewPassword.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UILabel *lbConfirmPassword = [UILabel labelWithText:NSLocalizedString(@"确认密码", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbConfirmPassword];
    [lbConfirmPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfNewPassword.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    self.tfConfirmPassword = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请确认您的新密码", nil) hasLine:YES];
    self.tfConfirmPassword.keyboardType = UIKeyboardTypeAlphabet;
    self.tfConfirmPassword.secureTextEntry = YES;
    [self addSubview:self.tfConfirmPassword];
    [self.tfConfirmPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbConfirmPassword.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UIButton *btnSure = [UIButton buttonWithTitle:NSLocalizedString(@"确定", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSureEvent:)];
    btnSure.backgroundColor = kRGB(0, 102, 237);
    btnSure.layer.cornerRadius = 4;
    [self addSubview:btnSure];
    [btnSure makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfConfirmPassword.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

@end
