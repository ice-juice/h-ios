//
//  WithdrawMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "WithdrawMainView.h"
#import "WithdrawPopupView.h"
#import "SafetyVerificationView.h"

#import "UserModel.h"
#import "AssetsModel.h"
#import "AssetsMainViewModel.h"

@interface WithdrawMainView ()
@property (nonatomic, strong) UILabel *lbSymbol;
@property (nonatomic, strong) UITextField *tfNumber;
@property (nonatomic, strong) UILabel *lbAvailable;     //可用余额
@property (nonatomic, strong) UILabel *lbFee;           //手续费
@property (nonatomic, strong) UILabel *lbTagTitle;
@property (nonatomic, strong) UITextField *tfTag;
@property (nonatomic, strong) UITextField *tfPassword;

@property (nonatomic, strong) UIView *passwordView;
@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) WithdrawPopupView *withdrawPopupView;
@property (nonatomic, strong) SafetyVerificationView *safetyView;

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat minPrice;
@property (nonatomic, assign) CGFloat maxPrice;
@property (nonatomic, assign) CGFloat availablePrice;    //可用余额
@property (nonatomic, assign) CGFloat minNumber;         //最小提币数量

@property (nonatomic, strong) UserModel *userModel;
//手续费率
@property (nonatomic, assign) CGFloat feeRatio;
@property (nonatomic, copy) NSString *usdtSymbol;

@end

@implementation WithdrawMainView
#pragma mark - Event Response
- (void)onBtnWithSelectSymbolEvent:(UIButton *)btn {
    //选择币种
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithSelectSymbol)]) {
        [self.delegate performSelector:@selector(mainViewWithSelectSymbol)];
    }
}

- (void)onBtnWithAllEvent:(UIButton *)btn {
    self.tfNumber.text = [NSString stringWithFormat:@"%.8f", self.availablePrice];
    //手续费 = 提币数量 * 对应币种提币手续费率
    CGFloat fee = (self.availablePrice * self.feeRatio) / 100;
    
    self.lbFee.text = [NSString stringWithFormat:@"%.4f %@", fee, self.usdtSymbol];
}

- (void)onBtnWithScanEvent:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanAddress)]) {
        [self.delegate performSelector:@selector(scanAddress)];
    }
    
}

- (void)onBtnWithForgetPasswordEvent:(UIButton *)btn {
    //忘记密码
    if (self.delegate && [self.delegate respondsToSelector:@selector(forgetAssetsPassword)]) {
        [self.delegate performSelector:@selector(forgetAssetsPassword)];
    }
}

- (void)onBtnWithdrawEvent:(UIButton *)btn {
    //提币
    if ([NSString isEmpty:self.tfNumber.text] || [self.tfNumber.text floatValue] <= 0) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入提币数量", nil) duration:2];
    }
    if ([self.tfNumber.text floatValue] < self.minNumber) {
        return [JYToastUtils showWithStatus:[NSString stringWithFormat:@"不得少于%.4f", self.minNumber] duration:2];
    }
    if ([NSString isEmpty:self.tfAddress.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入提币地址", nil) duration:2];
    }
    if ([self.lbSymbol.text isEqualToString:@"EOS"]) {
        if ([NSString isEmpty:self.tfTag.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入Memo值", nil) duration:2];
        }
    } else if ([self.lbSymbol.text isEqualToString:@"XRP"]) {
        if ([NSString isEmpty:self.tfTag.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入Tag值", nil) duration:2];
        }
    }
    if ([NSString isEmpty:self.tfPassword.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入资产密码", nil) duration:2];
    }
    [(AssetsMainViewModel *)self.mainViewModel setPrice:self.tfNumber.text];
    [(AssetsMainViewModel *)self.mainViewModel setToAddress:self.tfAddress.text];
    [(AssetsMainViewModel *)self.mainViewModel setMemoOrTagValue:self.tfTag.text];
    [(AssetsMainViewModel *)self.mainViewModel setPayPwd:self.tfPassword.text];
    [(AssetsMainViewModel *)self.mainViewModel stopCountDown];
    [self.safetyView updateCountDown:@"发送验证码" isEnd:YES];
    
    self.price = [self.tfNumber.text floatValue];
    if ([self.userModel.isOpenPay isEqualToString:@"N"] ||
        [NSString isEmpty:self.userModel.phone] ||
        [NSString isEmpty:self.userModel.email]) {
        [self.withdrawPopupView showView];
    } else {
        //三者都绑定了，判断提币数量在区间的状态
        //1.price < minPrice (资产密码)
        //2. min < price < max (手机验证)
        //3. price > max  手机验证-邮箱验证
        [(AssetsMainViewModel *)self.mainViewModel setAccount:self.userModel.phone];
        if (self.minPrice <= self.price && self.price <= self.maxPrice) {
            [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypePhone];
        } else if (self.price > self.maxPrice) {
            [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypePhoneValidate];
        } else {
            //提币
            if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithSubmitWithdraw)]) {
                [self.delegate performSelector:@selector(mainViewWithSubmitWithdraw)];
            }
        }
    }
}

- (void)onTextFieldChangeValue:(UITextField *)textField {
    //手续费 = 提币数量 * 对应币种提币手续费率
    CGFloat fee = ([textField.text floatValue] * self.feeRatio) / 100;
    self.lbFee.text = [NSString stringWithFormat:@"%.4f %@", fee, self.usdtSymbol];
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.lbSymbol = [UILabel labelWithText:@"USDT" textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:self.lbSymbol];
    [self.lbSymbol makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 20);
        make.left.equalTo(15);
    }];
    
    UIButton *btnSelectCoin = [UIButton buttonWithTitle:NSLocalizedString(@"选择币种", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithSelectSymbolEvent:)];
    [btnSelectCoin setImage:[UIImage imageNamed:@"xianyou"] forState:UIControlStateNormal];
    CGFloat btnW = [btnSelectCoin.titleLabel.text widthForFont:kFont(12) maxHeight:30] + 20;
    [self addSubview:btnSelectCoin];
    [btnSelectCoin makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(self.lbSymbol);
        make.width.equalTo(btnW);
        make.height.equalTo(30);
    }];
    [btnSelectCoin setTitleLeftSpace:10];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
        make.top.equalTo(btnSelectCoin.mas_bottom);
    }];
    
    UIView *numberView = [self createViewWithTitle:@"提币数量" placeHolder:@"" index:0];
    [self addSubview:numberView];
    [numberView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(75);
    }];
    
    UILabel *lbAvailableTitle = [UILabel labelWithText:NSLocalizedString(@"可用余额：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbAvailableTitle];
    [lbAvailableTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberView.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbAvailable = [UILabel labelWithText:@"" textColor:kRedColor font:kFont(12)];
    [self addSubview:self.lbAvailable];
    [self.lbAvailable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbAvailableTitle);
        make.right.equalTo(-15);
    }];
    
    UILabel *lbFeeTitle = [UILabel labelWithText:NSLocalizedString(@"手续费：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbFeeTitle];
    [lbFeeTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(lbAvailableTitle.mas_bottom).offset(10);
    }];
    
    self.lbFee = [UILabel labelWithText:@"" textColor:kRedColor font:kFont(12)];
    [self addSubview:self.lbFee];
    [self.lbFee makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbFeeTitle);
        make.right.equalTo(-15);
    }];
    
    UIView *addressView = [self createViewWithTitle:@"提币地址" placeHolder:@"" index:1];
    [self addSubview:addressView];
    [addressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbFee.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(75);
    }];
    
    self.tagView = [self createViewWithTitle:@"Memo值" placeHolder:@"请输入或粘贴EOS提币Memo值" index:2];
    self.tagView.hidden = YES;
    [self addSubview:self.tagView];
    [self.tagView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(75);
    }];
    
    self.passwordView = [self createViewWithTitle:@"资产密码" placeHolder:@"请输入资产密码" index:3];
    [self addSubview:self.passwordView];
    [self.passwordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbFee.mas_bottom).offset(75);
        make.left.right.equalTo(0);
        make.height.equalTo(75);
    }];
    
    UIButton *btnForgetPassword = [UIButton buttonWithTitle:NSLocalizedString(@"忘记资产密码？", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnWithForgetPasswordEvent:)];
    [self addSubview:btnForgetPassword];
    [btnForgetPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom).offset(10);
        make.right.equalTo(-15);
    }];
    
    UIButton *btnWithdraw = [UIButton buttonWithTitle:NSLocalizedString(@"提币", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithdrawEvent:)];
    btnWithdraw.backgroundColor = kRGB(0, 102, 237);
    btnWithdraw.layer.cornerRadius = 2;
    btnWithdraw.custom_acceptEventInterval = 3;
    [self addSubview:btnWithdraw];
    [btnWithdraw makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom).offset(50);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    UIImageView *imgViewTip = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"wxts"]];
    [self addSubview:imgViewTip];
    [imgViewTip makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(20);
        make.top.equalTo(btnWithdraw.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    UILabel *lbTipTitle = [UILabel labelWithText:NSLocalizedString(@"温馨提示：", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbTipTitle];
    [lbTipTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgViewTip);
        make.left.equalTo(imgViewTip.mas_right).offset(10);
    }];
    
    UILabel *lbTip = [UILabel labelWithText:NSLocalizedString(@"*手续费仅作参考，实际请以具体到账数额为准", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
    lbTip.numberOfLines = 0;
    [self addSubview:lbTip];
    [lbTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(imgViewTip.mas_bottom).offset(10);
        make.right.equalTo(-10);
    }];
}

- (void)updateView {
    NSString *symbol = [(AssetsMainViewModel *)self.mainViewModel symbol];
    self.lbSymbol.text = symbol;
    AssetsModel *assetsModel = [(AssetsMainViewModel *)self.mainViewModel withdrawInfoModel];
    self.minPrice = [assetsModel.minSection floatValue];
    self.maxPrice = [assetsModel.maxSection floatValue];
    if ([symbol isEqualToString:@"EOS"]) {
        self.tagView.hidden = NO;
        self.lbTagTitle.text = NSLocalizedString(@"Memo值", nil);
        self.tfTag.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入或粘贴EOS提币Memo值", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        [self.passwordView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lbFee.mas_bottom).offset(150);
        }];
    } else if ([symbol isEqualToString:@"XRP"]) {
        self.tagView.hidden = NO;
        self.lbTagTitle.text = NSLocalizedString(@"Tag值", nil);
        self.tfTag.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入或粘贴XRP提币Tag值", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        [self.passwordView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lbFee.mas_bottom).offset(150);
        }];
    }
    
    self.usdtSymbol = symbol;
    if ([self.usdtSymbol containsString:@"USDT"]) {
        self.usdtSymbol = @"USDT";
    }
    self.lbAvailable.text = [NSString stringWithFormat:@"%.4f %@", [assetsModel.price floatValue], self.usdtSymbol];
    self.tfNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%.4f %@", NSLocalizedString(@"最少提币数量", nil), [assetsModel.min floatValue], self.usdtSymbol] attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    self.minNumber = [assetsModel.min floatValue];
    //手续费
    self.feeRatio = [assetsModel.fee floatValue];
    self.lbFee.text = [NSString stringWithFormat:@"0.0000 %@", self.usdtSymbol];

    self.userModel = [(AssetsMainViewModel *)self.mainViewModel userModel];
    self.withdrawPopupView.imgName0 = [self.userModel.isOpenPay isEqualToString:@"Y"] ? @"zctk-wxz-1" : @"zctk-wxz-2";
    
    if ([self.userModel.loginMethod isEqualToString:@"PHONE"]) {
        if ([NSString isEmpty:self.userModel.email]) {
            //未绑定邮箱
            self.withdrawPopupView.imgName1 = @"zctk-wxz-2";
        } else {
            //绑定了邮箱
            self.withdrawPopupView.imgName1 = @"zctk-wxz-1";
        }
        self.withdrawPopupView.title = @"开启邮箱验证";
    } else {
        if ([NSString isEmpty:self.userModel.phone]) {
            //未绑定手机
            self.withdrawPopupView.imgName1 = @"zctk-wxz-2";
        } else {
            self.withdrawPopupView.imgName1 = @"zctk-wxz-1";
        }
        self.withdrawPopupView.title = @"开启手机验证";
    }
    
    if ([self.userModel.isOpenPay isEqualToString:@"N"] ||
        [NSString isEmpty:self.userModel.phone] ||
        [NSString isEmpty:self.userModel.email]) {
        [self.withdrawPopupView showView];
    } 
    
    self.availablePrice = [assetsModel.price floatValue];
    
    self.tfAddress.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"请输入或粘贴", nil), self.lbSymbol.text, NSLocalizedString(@"提币地址", nil)] attributes:@{NSForegroundColorAttributeName : kRGB(153, 153, 153)}];
    
    self.tfNumber.text = @"";
    self.tfTag.text = @"";
    self.tfPassword.text = @"";
}

- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd {
    [self.safetyView updateCountDown:countDown isEnd:isEnd];
}

- (void)updateSafetyView {
    [self.safetyView showViewWithVerifyCodeType:VerifyCodeTypeEmail];
}

- (UIView *)createViewWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder index:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(title, nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [view addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIButton *btnAll = [UIButton buttonWithTitle:NSLocalizedString(@"全部", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnWithAllEvent:)];
    btnAll.frame = CGRectMake(0, 0, 50, 50);
    btnAll.hidden = YES;
    [rightView addSubview:btnAll];
    
    UIButton *btnScan = [UIButton buttonWithImageName:@"tb-sys" highlightedImageName:@"tb-sys" target:self selector:@selector(onBtnWithScanEvent:)];
    btnScan.frame = CGRectMake(0, 0, 50, 50);
    btnScan.hidden = YES;
    [rightView addSubview:btnScan];
    
    UITextField *textField = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(placeHolder, nil) hasLine:YES];
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeNever;
    textField.keyboardType = UIKeyboardTypeDefault;
    [view addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    if (index == 0) {
        self.tfNumber = textField;
        btnAll.hidden = NO;
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(onTextFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    } else if (index == 1) {
        self.tfAddress = textField;
        btnScan.hidden = NO;
        textField.rightViewMode = UITextFieldViewModeAlways;
    } else if (index == 2) {
        self.tfTag = textField;
        self.lbTagTitle = lbTitle;
    } else {
        self.tfPassword = textField;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.secureTextEntry = YES;
    }
    return view;
}

#pragma mark - Setter & Getter
- (WithdrawPopupView *)withdrawPopupView {
    if (!_withdrawPopupView) {
        _withdrawPopupView = [[WithdrawPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_withdrawPopupView setOnGoSafetyBlock:^{
            //前往安全设置
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(goSafety)]) {
                [weakSelf.delegate performSelector:@selector(goSafety)];
            }
        }];
    }
    return _withdrawPopupView;
}

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
            if (weakSelf.minPrice <= weakSelf.price && weakSelf.price <= weakSelf.maxPrice) {
                //提交提币
                [(AssetsMainViewModel *)weakSelf.mainViewModel setSmsCode:verifyCode];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithSubmitWithdraw)]) {
                    [weakSelf.delegate performSelector:@selector(mainViewWithSubmitWithdraw)];
                }
            } else if (weakSelf.price > weakSelf.maxPrice) {
                if (weakSelf.safetyView.verifyCodeType == VerifyCodeTypeEmail) {
                    //提交提币
                    [(AssetsMainViewModel *)weakSelf.mainViewModel setEmailCode:verifyCode];
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithSubmitWithdraw)]) {
                        [weakSelf.delegate performSelector:@selector(mainViewWithSubmitWithdraw)];
                    }
                } else {
                    //获取邮箱验证码
                    [(AssetsMainViewModel *)weakSelf.mainViewModel setSmsCode:verifyCode];
                    [(AssetsMainViewModel *)weakSelf.mainViewModel stopCountDown];
                    [weakSelf.safetyView updateCountDown:NSLocalizedString(@"发送验证码", nil) isEnd:YES];
                    [(AssetsMainViewModel *)weakSelf.mainViewModel setAccount:weakSelf.userModel.email];
                    [weakSelf.safetyView changeViewWithVerifyCodeType:VerifyCodeTypeEmail];
                }
            }
        }];
    }
    return _safetyView;
}

@end
