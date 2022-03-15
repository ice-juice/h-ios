//
//  BindMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BindMainView.h"
#import "SafetyVerificationView.h"

#import "DataModel.h"
#import "HomeMainViewModel.h"

@interface BindMainView ()
@property (nonatomic, strong) UITextField *tfAccount;
@property (nonatomic, strong) SafetyVerificationView *safetyView;

@end

@implementation BindMainView
#pragma mark - Event Response
- (void)onBtnWithSelectAreaCodeEvent:(UIButton *)btn {
    //选择手机区号
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectPhoneCode)]) {
        [self.delegate performSelector:@selector(selectPhoneCode)];
    }
}

- (void)onBtnWithNextEvent:(UIButton *)btn {
    //停止定时器
    [(HomeMainViewModel *)self.mainViewModel stopCountDown];
    BindType bindType = [(HomeMainViewModel *)self.mainViewModel bindType];
    [(HomeMainViewModel *)self.mainViewModel setAccount:@""];
    [self.tfAccount resignFirstResponder];
    if (bindType == BindTypeEmail) {
        //绑定邮箱
        if ([NSString isEmpty:self.tfAccount.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入邮箱号", nil) duration:2];
        }
        if (![self.tfAccount.text containsString:@"@"]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入正确邮箱号", nil) duration:2];
        }
        //第一步：发送手机验证码
        [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypePhoneValidate];
    } else {
        //绑定手机
        if ([NSString isEmpty:self.tfAccount.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入手机号", nil) duration:2];
        }
        if (self.tfAccount.text.length < 5 || self.tfAccount.text.length > 15) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入5-15位手机号", nil) duration:2];
        }
        //第一步：发送邮箱验证码
        [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypeEmailValidate];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
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
    [self addSubview:self.tfAccount];
    [self.tfAccount makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.height.equalTo(40);
        make.right.equalTo(-15);
        make.top.equalTo(kNavBarHeight + 20);
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
}

- (void)updateView {
    BindType bindType = [(HomeMainViewModel *)self.mainViewModel bindType];
    if (bindType == BindTypePhone) {
        //绑定手机
        self.tfAccount.leftViewMode = UITextFieldViewModeAlways;
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入手机号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfAccount.keyboardType = UIKeyboardTypePhonePad;
    } else {
        //绑定邮箱
        self.tfAccount.leftViewMode = UITextFieldViewModeNever;
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入邮箱号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfAccount.keyboardType = UIKeyboardTypeEmailAddress;
    }
    [self.tfAccount becomeFirstResponder];
}

- (void)updateVerifyCodeResult {
    [(HomeMainViewModel *)self.mainViewModel stopCountDown];
    [self.safetyView updateCountDown:@"发送验证码" isEnd:YES];
    DataModel *dataModel = [(HomeMainViewModel *)self.mainViewModel dataModel];
    if ([dataModel.isTrue isEqualToString:@"N"]) {
        //验证码不正确
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入正确的验证码", nil) duration:2];
    } else {
        [(HomeMainViewModel *)self.mainViewModel setAccount:self.tfAccount.text];
        BindType bindType = [(HomeMainViewModel *)self.mainViewModel bindType];
        if (bindType == BindTypePhone) {
            //第二步：发送手机验证码
            [self.safetyView changeViewWithVerifyCodeType:VerifyCodeTypePhone];
        } else {
            //第二步：发送邮箱验证码
            [self.safetyView changeViewWithVerifyCodeType:VerifyCodeTypeEmail];
        }
    }
}

- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd {
    [self.safetyView updateCountDown:countDown isEnd:isEnd];
}

#pragma mark - Setter & Getter
- (SafetyVerificationView *)safetyView {
    if (!_safetyView) {
        _safetyView = [[SafetyVerificationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_safetyView setOnBtnWithSendVerifyCodeBlock:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithSendVerifyCode)]) {
                [weakSelf.delegate performSelector:@selector(mainViewWithSendVerifyCode)];
            }
        }];
        [_safetyView setOnBtnWithSubmitRegisterBlock:^(NSString * _Nonnull verifyCode) {
            if (weakSelf.safetyView.verifyCodeType == VerifyCodeTypeEmailValidate || weakSelf.safetyView.verifyCodeType == VerifyCodeTypePhoneValidate) {
                //验证验证码
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithVerificationCode:)]) {
                    [weakSelf.delegate performSelector:@selector(mainViewWithVerificationCode:) withObject:verifyCode];
                }
            } else {
                //绑定邮箱或手机
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithBinding:)]) {
                    [weakSelf.delegate performSelector:@selector(mainViewWithBinding:) withObject:verifyCode];
                }
                [weakSelf.safetyView closeView];
            }
        }];
        [_safetyView setOnBtnWithCloseViewBlock:^{
            //中途关闭视图时，将账号为空
            [(HomeMainViewModel *)weakSelf.mainViewModel setAccount:@""];
        }];
    }
    return _safetyView;
}

@end
