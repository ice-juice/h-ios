//
//  RegisterMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RegisterMainView.h"
#import "SafetyVerificationView.h"

#import "LoginMainViewModel.h"

@interface RegisterMainView ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;

@property (nonatomic, strong) UITextField *tfAccount;
@property (nonatomic, strong) UITextField *tfPassword;
@property (nonatomic, strong) UITextField *tfInviteCode;
@property (nonatomic, strong) UIButton *btnRegister;

@property (nonatomic, strong) SafetyVerificationView *safetyView;

//是否已阅读并接受协议，默认为0
@property (nonatomic, assign) NSInteger isSelected;
//注册方式 0-手机注册 1-邮箱注册 （默认手机注册）
@property (nonatomic, assign) NSInteger registerMethod;

@end

@implementation RegisterMainView
#pragma mark - Event Response
- (void)onBtnWithSwitchRegisterEvent:(UIButton *)btn {
    //切换注册方式
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.titleLabel.font = kBoldFont(30);
            obj.selected = YES;
        } else {
            obj.titleLabel.font = kFont(20);
            obj.selected = NO;
        }
    }];
    self.registerMethod = index;
    if (index == 0) {
        //手机注册
        self.tfAccount.leftViewMode = UITextFieldViewModeAlways;
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入手机号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfAccount.keyboardType = UIKeyboardTypePhonePad;
    } else {
        //邮箱注册
        self.tfAccount.leftViewMode = UITextFieldViewModeNever;
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入邮箱号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfAccount.keyboardType = UIKeyboardTypeEmailAddress;
    }
}

- (void)onBtnWithSelectAreaCodeEvent:(UIButton *)btn {
    //选择区号
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectPhoneCode)]) {
        [self.delegate performSelector:@selector(selectPhoneCode)];
    }
}

- (void)onBtnWithSeePasswordEvent:(UIButton *)btn {
    //是否隐藏密码
    btn.selected = !btn.selected;
    self.tfPassword.secureTextEntry = !btn.selected;
}

- (void)onBtnWithReceiveProtocolEvent:(UIButton *)btn {
    //是否接受服务条款
    btn.selected = !btn.selected;
    self.isSelected = btn.selected;
    self.btnRegister.backgroundColor = btn.selected ? kRGB(0, 102, 237) : [UIColor grayColor];
}

- (void)onBtnWithRegisterEvent:(UIButton *)btn {
    //注册
    if (self.registerMethod == 0) {
        //手机注册
        if ([NSString isEmpty:self.tfAccount.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入手机号", nil) duration:2];
        }
        if (self.tfAccount.text.length < 5 || self.tfAccount.text.length > 15) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入5-15位手机号", nil) duration:2];
        }
    } else {
        //邮箱注册
        if ([NSString isEmpty:self.tfAccount.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入邮箱号", nil) duration:2];
        }
        if (![self.tfAccount.text containsString:@"@"]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入正确的邮箱地址", nil) duration:2];
        }
    }
    if ([NSString isEmpty:self.tfPassword.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入密码", nil) duration:2];
    }
    if (self.tfPassword.text.length < 6 || self.tfPassword.text.length > 18) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请设置6-18位登录密码", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfInviteCode.text]) {
        [JYToastUtils showWithStatus:NSLocalizedString(@"请输入邀请码", nil) duration:2];
        return;
    }
    if (!self.isSelected) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请勾选协议", nil) duration:2];
    }
    [(LoginMainViewModel *)self.mainViewModel setAccount:self.tfAccount.text];
    [(LoginMainViewModel *)self.mainViewModel setPassword:self.tfPassword.text];
    [(LoginMainViewModel *)self.mainViewModel setInviteCode:self.tfInviteCode.text];
    //停止倒计时
    [(LoginMainViewModel *)self.mainViewModel stopCountDown];
    if (self.registerMethod == 0) {
        //手机发送验证码
        [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypePhone];
    } else {
        //邮箱发送验证码
        [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypeEmail];
    }
}

- (void)onLabelWithLoginEvent {
    //登录
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithLogin)]) {
        [self.delegate performSelector:@selector(mainViewWithLogin)];
    }
}

- (void)onCheckProtocolEvent:(UITapGestureRecognizer *)gester {
    //服务条款、隐私政策
    NSString *protocolType = gester.view.tag == 100 ? @"SERVER_INFO" : @"PRIMARY";
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithCheckProtocol:)]) {
        [self.delegate performSelector:@selector(mainViewWithCheckProtocol:) withObject:protocolType];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    if (self.arrayBtns) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayBtns removeAllObjects];
    }
    [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(153, 153, 153) highlightedTitleColor:kRGB(153, 153, 153) font:kFont(20) target:self selector:@selector(onBtnWithSwitchRegisterEvent:)];
        btn.tag = 1000 + idx;
        [btn setTitleColor:kRGB(16, 16, 16) forState:UIControlStateSelected];
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kNavBarHeight + 30);
            make.left.equalTo(15 + idx * 130);
            make.width.equalTo(130);
            make.height.equalTo(40);
        }];
        [self.arrayBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
            btn.titleLabel.font = kBoldFont(30);
        }
    }];
    
    UILabel *lbLogin = [UILabel labelWithText:NSLocalizedString(@"已有账号？立即登录", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    lbLogin.attributedText = [lbLogin.text attributedStringWithSubString:NSLocalizedString(@"立即登录", nil) subColor:kRGB(0, 102, 237)];
    [lbLogin addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelWithLoginEvent)]];
    lbLogin.userInteractionEnabled = YES;
    [self addSubview:lbLogin];
    [lbLogin makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(kNavBarHeight + 80);
    }];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    self.btnAreaCode = [UIButton buttonWithTitle:@"+86" titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithSelectAreaCodeEvent:)];
    self.btnAreaCode.frame = CGRectMake(0, 0, 30, 40);
    [leftView addSubview:self.btnAreaCode];
    
    UIView *lineLeftView = [[UIView alloc] initWithFrame:CGRectMake(40, 15, 0.5, 10)];
    lineLeftView.backgroundColor = kRGB(153, 153, 153);
    [leftView addSubview:lineLeftView];
    
    self.tfAccount = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入手机号", nil) hasLine:YES];
    self.tfAccount.keyboardType = UIKeyboardTypePhonePad;
    self.tfAccount.leftView = leftView;
    self.tfAccount.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.tfAccount];
    [self.tfAccount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.height.equalTo(40);
        make.right.equalTo(-15);
        make.top.equalTo(lbLogin.mas_bottom).offset(46);
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
    
    self.tfInviteCode = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入邀请码(必填)", nil) hasLine:YES];
    self.tfInviteCode.keyboardType = UIKeyboardTypeAlphabet;
    [self addSubview:self.tfInviteCode];
    [self.tfInviteCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPassword.mas_bottom).offset(7);
        make.left.right.height.equalTo(self.tfPassword);
    }];
    
    UIButton *btnReceive = [UIButton buttonWithImageName:@"zctk-wxz" highlightedImageName:@"zctk-wxz" target:self selector:@selector(onBtnWithReceiveProtocolEvent:)];
    [btnReceive setImage:[UIImage imageNamed:@"zctk-wxz-1"] forState:UIControlStateSelected];
    [self addSubview:btnReceive];
    [btnReceive makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(30);
        make.left.equalTo(0);
        make.top.equalTo(self.tfInviteCode.mas_bottom).offset(12);
    }];
    
    UILabel *lbService = [UILabel labelWithText:NSLocalizedString(@"已阅读并接受《服务条款》", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    lbService.attributedText = [lbService.text attributedStringWithSubString:@"《服务条款》" subColor:kRGB(0, 102, 237)];
    lbService.tag = 100;
    lbService.userInteractionEnabled = YES;
    [lbService addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCheckProtocolEvent:)]];
    [self addSubview:lbService];
    [lbService makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnReceive);
        make.left.equalTo(btnReceive.mas_right);
    }];
    
    UILabel *lbPrivate = [UILabel labelWithText:NSLocalizedString(@"《隐私政策》", nil) textColor:kRGB(0, 102, 237) font:kFont(12)];
    lbPrivate.tag = 101;
    lbPrivate.userInteractionEnabled = YES;
    [lbPrivate addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCheckProtocolEvent:)]];
    [self addSubview:lbPrivate];
    [lbPrivate makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbService);
        make.left.equalTo(lbService.mas_right);
    }];
    
    self.btnRegister = [UIButton buttonWithTitle:NSLocalizedString(@"注册", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithRegisterEvent:)];
    self.btnRegister.backgroundColor = [UIColor grayColor];
    self.btnRegister.layer.cornerRadius = 4;
    [self addSubview:self.btnRegister];
    [self.btnRegister makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfInviteCode.mas_bottom).offset(66);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    self.registerMethod = 0;
    self.isSelected = 0;
}

- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd {
    [self.safetyView updateCountDown:countDown isEnd:isEnd];
}

#pragma mark - Setter & Getter
- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayBtns;
}

- (NSArray<NSString *> *)arrayBtnTitles {
    if (!_arrayBtnTitles) {
        _arrayBtnTitles = @[@"手机注册", @"邮箱注册"];
    }
    return _arrayBtnTitles;
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
            //注册
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithRegister:)]) {
                [weakSelf.delegate performSelector:@selector(mainViewWithRegister:) withObject:verifyCode];
            }
        }];
    }
    return _safetyView;
}

@end
