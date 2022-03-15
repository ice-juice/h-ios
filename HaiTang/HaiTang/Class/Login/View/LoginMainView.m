//
//  LoginMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "LoginMainView.h"

#import "LoginMainViewModel.h"

@interface LoginMainView ()
@property (nonatomic, strong) UITextField *tfAccount;
@property (nonatomic, strong) UITextField *tfPassword;

@end

@implementation LoginMainView
#pragma mark - Event Response
- (void)onBtnWithSeePasswordEvent:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.tfPassword.secureTextEntry = !btn.selected;
}

- (void)onBtnWithForgetPasswordEvent:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithForgetPassword)]) {
        [self.delegate performSelector:@selector(mainViewWithForgetPassword)];
    }
}

- (void)onBtnWithLoginEvent:(UIButton *)btn {
    if ([NSString isEmpty:self.tfAccount.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入账号", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfPassword.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入密码", nil) duration:2];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithLogin:password:)]) {
        [self.delegate performSelector:@selector(mainViewWithLogin:password:) withObject:self.tfAccount.text withObject:self.tfPassword.text];
    }
}

- (void)onLabelWithRegisterEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithRegister)]) {
        [self.delegate performSelector:@selector(mainViewWithRegister)];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UILabel *lbTitle = [[UILabel alloc] init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"登录", nil) attributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Semibold" size:30], NSForegroundColorAttributeName : kRGB(16, 16, 16)}];
    lbTitle.attributedText = string;
    lbTitle.textColor = kRGB(16, 16, 16);
    [self addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(30 + kNavBarHeight);
    }];
    
    UILabel *lbRegister = [UILabel labelWithText:NSLocalizedString(@"还没有账号？立即注册", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    lbRegister.attributedText = [lbRegister.text attributedStringWithSubString:NSLocalizedString(@"立即注册", nil) subColor:kRGB(0, 102, 237)];
    [lbRegister addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelWithRegisterEvent)]];
    lbRegister.userInteractionEnabled = YES;
    [self addSubview:lbRegister];
    [lbRegister makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(lbTitle.mas_bottom).offset(10);
    }];
    
    self.tfAccount = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入邮箱或手机号", nil) hasLine:YES];
    self.tfAccount.keyboardType = UIKeyboardTypeEmailAddress;
    [self addSubview:self.tfAccount];
    [self.tfAccount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.height.equalTo(40);
        make.right.equalTo(-15);
        make.top.equalTo(lbRegister.mas_bottom).offset(46);
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *btnSee = [UIButton buttonWithImageName:@"unseen" highlightedImageName:@"unseen" target:self selector:@selector(onBtnWithSeePasswordEvent:)];
    [btnSee setImage:[UIImage imageNamed:@"seen"] forState:UIControlStateSelected];
    btnSee.frame = CGRectMake(0, 0, 40, 40);
    [rightView addSubview:btnSee];
    self.tfPassword = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入登录密码", nil) hasLine:YES];
    self.tfPassword.secureTextEntry = YES;
    self.tfPassword.keyboardType = UIKeyboardTypeAlphabet;
    self.tfPassword.rightView = rightView;
    self.tfPassword.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.tfPassword];
    [self.tfPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfAccount.mas_bottom).offset(7);
        make.left.right.height.equalTo(self.tfAccount);
    }];
    
    UIButton *btnForget = [UIButton buttonWithTitle:NSLocalizedString(@"忘记密码", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithForgetPasswordEvent:)];
    [self addSubview:btnForget];
    [btnForget makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(self.tfPassword.mas_bottom).offset(10);
    }];
    
    UIButton *btnLogin = [UIButton buttonWithTitle:NSLocalizedString(@"登录", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithLoginEvent:)];
    btnLogin.backgroundColor = kRGB(0, 102, 237);
    btnLogin.layer.cornerRadius = 4;
    [self addSubview:btnLogin];
    [btnLogin makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPassword.mas_bottom).offset(66);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

- (void)updateView {
    self.tfAccount.text = @"";
    self.tfPassword.text = @"";
}

@end
