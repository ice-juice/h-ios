//
//  SafetyVerificationView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SafetyVerificationView.h"

@interface SafetyVerificationView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *lbSubTitle;
@property (nonatomic, strong) UITextField *tfVerifyCode;
@property (nonatomic, strong) UIButton *btnVerifyCode;

@end

@implementation SafetyVerificationView
#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 516, self.frame.size.width, 258)];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 258, self.frame.size.width, 258)];
}

- (void)keyboardDidHide:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 258, self.frame.size.width, 258)];
}

#pragma mark - Event Response
- (void)onBtnWithCloseEvent:(UIButton *)btn {
    if (self.onBtnWithCloseViewBlock) {
        self.onBtnWithCloseViewBlock();
    }
    [self closeView];
}

- (void)onBtnWithSendVerifyCodeEvent:(UIButton *)btn {
    //获取验证码
    if (self.onBtnWithSendVerifyCodeBlock) {
        self.onBtnWithSendVerifyCodeBlock();
    }
}

- (void)onBtnWithSubmitEvent:(UIButton *)btn {
    if ([NSString isEmpty:self.tfVerifyCode.text] || self.tfVerifyCode.text.length != 6) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入正确的短信验证码", nil) duration:2];
    }
    if (self.verifyCodeType == VerifyCodeTypeEmail || self.verifyCodeType == VerifyCodeTypePhone) {
        //不需要检验验证码
        [self closeView];
    }
    
    [self.tfVerifyCode resignFirstResponder];
    
    if (self.onBtnWithSubmitRegisterBlock) {
        self.onBtnWithSubmitRegisterBlock(self.tfVerifyCode.text);
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1;
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12;
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(12);
        make.height.equalTo(258);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"安全验证", nil) textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
    [self.contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(19);
    }];
    
    UIButton *btnClose = [UIButton buttonWithImageName:@"belvedere_ic_close" highlightedImageName:@"belvedere_ic_close" target:self selector:@selector(onBtnWithCloseEvent:)];
    [self.contentView addSubview:btnClose];
    [btnClose makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(36);
        make.top.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    self.lbSubTitle = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kBoldFont(12)];
    [self.contentView addSubview:self.lbSubTitle];
    [self.lbSubTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(8);
        make.left.equalTo(15);
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    self.btnVerifyCode = [UIButton buttonWithTitle:NSLocalizedString(@"获取验证码", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithSendVerifyCodeEvent:)];
    self.btnVerifyCode.frame = CGRectMake(0, 5, 90, 30);
    [rightView addSubview:self.btnVerifyCode];
    
    self.tfVerifyCode = [[UITextField alloc] initNoLeftViewWithPlaceHolder:@"" hasLine:YES];
    self.tfVerifyCode.keyboardType = UIKeyboardTypeNumberPad;
    self.tfVerifyCode.rightView = rightView;
    self.tfVerifyCode.rightViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.tfVerifyCode];
    [self.tfVerifyCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbSubTitle.mas_bottom).offset(17);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UIButton *btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"提交", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSubmitEvent:)];
    btnSubmit.backgroundColor = kRGB(0, 102, 237);
    btnSubmit.layer.cornerRadius = 4;
    [self.contentView addSubview:btnSubmit];
    [btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-59);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd {
    //刷新倒计时
    [self.btnVerifyCode setTitle:countDown forState:UIControlStateNormal];
    self.btnVerifyCode.userInteractionEnabled = isEnd;
}

- (void)showViewWithVerifyCodeType:(VerifyCodeType)verifyCodeType {
    self.tfVerifyCode.text = @"";
    [self updateCountDown:NSLocalizedString(@"获取验证码", nil) isEnd:YES];
    if (verifyCodeType == VerifyCodeTypePhone || verifyCodeType == VerifyCodeTypePhoneValidate) {
        //手机
        self.lbSubTitle.text = NSLocalizedString(@"短信验证码", nil);
        self.tfVerifyCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入短信验证码", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    } else {
        //邮箱
        self.lbSubTitle.text = NSLocalizedString(@"邮箱验证码", nil);
        self.tfVerifyCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入邮箱验证码", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    }
    self.verifyCodeType = verifyCodeType;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 258)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, kScreenHeight - 258, kScreenWidth, 258)];
    }];
}

- (void)changeViewWithVerifyCodeType:(VerifyCodeType)verifyCodeType {
    self.tfVerifyCode.text = @"";
    [self updateCountDown:NSLocalizedString(@"获取验证码", nil) isEnd:YES];
    if (verifyCodeType == VerifyCodeTypePhone || verifyCodeType == VerifyCodeTypePhoneValidate) {
        //手机
        self.lbSubTitle.text = NSLocalizedString(@"短信验证码", nil);
        self.tfVerifyCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入正确的短信验证码", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    } else {
        //邮箱
        self.lbSubTitle.text = NSLocalizedString(@"邮箱验证码", nil);
        self.tfVerifyCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入正确的邮箱验证码", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    }
    self.verifyCodeType = verifyCodeType;
}

- (void)closeView {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 258)];
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
