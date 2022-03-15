//
//  ForgetPasswordMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ForgetPasswordMainView.h"
#import "SafetyVerificationView.h"

#import "LoginMainViewModel.h"

@interface ForgetPasswordMainView ()
@property (nonatomic, strong) UITextField *tfAccount;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;

@property (nonatomic, strong) SafetyVerificationView *safetyView;

//0-手机 1-邮箱(默认手机)
@property (nonatomic, assign) NSInteger selectType;

@end

@implementation ForgetPasswordMainView
#pragma mark - Event Response
- (void)onBtnWithSwitchAccountEvent:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = YES;
            obj.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        } else {
            obj.selected = NO;
            obj.titleLabel.font = kFont(14);
        }
    }];
    if (index == 0) {
        //手机
        self.tfAccount.leftViewMode = UITextFieldViewModeAlways;
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入手机号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfAccount.keyboardType = UIKeyboardTypePhonePad;
    } else {
        //邮箱
        self.tfAccount.leftViewMode = UITextFieldViewModeNever;
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入邮箱号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfAccount.keyboardType = UIKeyboardTypeEmailAddress;
    }
    self.selectType = index;
}

- (void)onBtnWithSelectAreaCodeEvent:(UIButton *)btn {
    //选择区号
}

- (void)onBtnWithNextEvent:(UIButton *)btn {
    [self.tfAccount resignFirstResponder];
    
    //下一步
    NSString *tip = self.selectType == 0 ? @"请输入手机号" : @"请输入邮箱号";
    if ([NSString isEmpty:self.tfAccount.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(tip, nil) duration:2];
    }
    [(LoginMainViewModel *)self.mainViewModel setAccount:self.tfAccount.text];
    //停止倒计时
    [(LoginMainViewModel *)self.mainViewModel stopCountDown];
    if (self.selectType == 0) {
        //手机发送验证码
        [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypePhone];
    } else {
        //邮箱发送验证码
        [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypeEmail];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"忘记密码", nil) textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
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
    
    if (self.arrayBtns) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayBtns removeAllObjects];
    }
    [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(14) target:self selector:@selector(onBtnWithSwitchAccountEvent:)];
        [btn setTitleColor:kRGB(0, 102, 237) forState:UIControlStateSelected];
        btn.tag = idx + 1000;
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbSubTitle.mas_bottom).offset(56);
            make.left.equalTo(15 + 60 * idx);
            make.width.equalTo(60);
            make.height.equalTo(30);
        }];
        [self.arrayBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        }
    }];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    UIButton *btnAreaCode = [UIButton buttonWithTitle:@"+86" titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithSelectAreaCodeEvent:)];
    btnAreaCode.frame = CGRectMake(0, 0, 30, 40);
    [leftView addSubview:btnAreaCode];
    
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
        make.top.equalTo(lbSubTitle.mas_bottom).offset(95);
    }];
    
    UIButton *btnNext = [UIButton buttonWithTitle:NSLocalizedString(@"下一步", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithNextEvent:)];
    btnNext.backgroundColor = kRGB(0, 102, 237);
    btnNext.layer.cornerRadius = 4;
    [self addSubview:btnNext];
    [btnNext makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfAccount.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    self.selectType = 0;
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
        _arrayBtnTitles = @[@"手机", @"邮箱"];
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
            //下一步
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithNext:)]) {
                    [weakSelf.delegate performSelector:@selector(mainViewWithNext:) withObject:verifyCode];
                }
            });
        }];
    }
    return _safetyView;
}

@end
