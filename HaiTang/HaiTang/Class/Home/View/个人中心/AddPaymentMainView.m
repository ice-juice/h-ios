//
//  AddPaymentMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AddPaymentMainView.h"

#import "UserInfoManager.h"
#import "HomeMainViewModel.h"

@interface AddPaymentMainView ()
@property (nonatomic, strong) UITextField *tfName;              //姓名
@property (nonatomic, strong) UITextField *tfAccount;           //账号
@property (nonatomic, strong) UITextField *tfBankName;          //开户银行
@property (nonatomic, strong) UITextField *tfBankAddress;       //开户支行
@property (nonatomic, strong) UILabel *lbAccountTitle;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbOptional;               //选填
@property (nonatomic, strong) UIImageView *imgViewQRCode;        //收款二维码

@property (nonatomic, strong) UIView *bankNameView;
@property (nonatomic, strong) UIView *bankAddressView;
@property (nonatomic, strong) UIView *qrCodeView;

@end

@implementation AddPaymentMainView
#pragma mark - Event Response
- (void)onBtnWithSaveEvent:(UIButton *) btn {
    AddPaymentType addPaymenType = [(HomeMainViewModel *)self.mainViewModel addPaymentType];
    NSString *bank = @"";
    NSString *branch = @"";
    if (addPaymenType == AddPaymentTypeAlipay) {
        if ([NSString isEmpty:self.tfAccount.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入您本人支付宝账号", nil) duration:2];
        }
    } else if (addPaymenType == AddPaymentTypePayPal) {
        if ([NSString isEmpty:self.tfAccount.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入您本人PayPal账号", nil) duration:2];
        }
    } else if (addPaymenType == AddPaymentTypeWeChat) {
        if ([NSString isEmpty:self.tfAccount.text]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入微信号(手机号)", nil) duration:2];
        }
    } else if (addPaymenType == AddPaymentTypeBankCard) {
        if ([NSString isEmpty:self.tfName.text]) {
            [JYToastUtils showWithStatus:NSLocalizedString(@"请输入姓名", nil) duration:2];
            return;
        }
        if ([NSString isEmpty:self.tfAccount.text]) {
            [JYToastUtils showWithStatus:NSLocalizedString(@"请输入银行卡号", nil) duration:2];
            return;
        }
        if ([NSString isEmpty:self.tfBankName.text]) {
            [JYToastUtils showWithStatus:NSLocalizedString(@"请输入开户银行名称", nil) duration:2];
            return;
        }
        if ([NSString isEmpty:self.tfBankAddress.text]) {
            [JYToastUtils showWithStatus:NSLocalizedString(@"请输入开户银行支行", nil) duration:2];
            return;
        }
        bank = self.tfBankName.text;
        branch = self.tfBankAddress.text;
    }
    [(HomeMainViewModel *)self.mainViewModel setFistName:self.tfName.text];
    [(HomeMainViewModel *)self.mainViewModel setIdCard:self.tfAccount.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithAddPayment:address:)]) {
        [self.delegate performSelector:@selector(mainViewWithAddPayment:address:) withObject:bank withObject:branch];
    }
}

- (void)uploadQRCode {
    //添加收款二维码
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithUploadQRCode)]) {
        [self.delegate performSelector:@selector(mainViewWithUploadQRCode)];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *nameView = [self createView:@"姓名" subTitle:@"请输入姓名" index:0];
    [self addSubview:nameView];
    [nameView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(77);
    }];
    
    UIView *accountView = [self createView:@"账号" subTitle:@"请输入您本人支付宝账号" index:1];
    [self addSubview:accountView];
    [accountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom);
        make.left.right.height.equalTo(nameView);
    }];
    
    self.bankNameView = [self createView:@"开户银行" subTitle:@"请输入开户银行名称" index:2];
    self.bankNameView.hidden = YES;
    [self addSubview:self.bankNameView];
    [self.bankNameView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_bottom);
        make.left.right.height.equalTo(accountView);
    }];
    
    self.bankAddressView = [self createView:@"开户支行(地址)" subTitle:@"请输入开户银行支行(地址)" index:3];
    self.bankAddressView.hidden = YES;
    [self addSubview:self.bankAddressView];
    [self.bankAddressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameView.mas_bottom);
        make.left.right.height.equalTo(self.bankNameView);
    }];
    
    [self addSubview:self.qrCodeView];
    [self.qrCodeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(200);
    }];
    
    UIButton *btnSave = [UIButton buttonWithTitle:NSLocalizedString(@"保存", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSaveEvent:)];
    btnSave.backgroundColor = kRGB(0, 102, 237);
    btnSave.layer.cornerRadius = 4;
    [self addSubview:btnSave];
    [btnSave makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_bottom).offset(215);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

- (UIView *)createView:(NSString *)title subTitle:(NSString *)subTitle index:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(title, nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [view addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
    }];
    
    UITextField *textField = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(subTitle, nil) hasLine:YES];
    [view addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    if (index == 0) {
        self.tfName = textField;
    } else if (index == 1) {
        self.tfAccount = textField;
        textField.keyboardType = UIKeyboardTypeAlphabet;
    } else if (index == 2) {
        self.tfBankName = textField;
    } else if (index == 3) {
        self.tfBankAddress = textField;
    }
    return view;
}

- (void)updateView {
    AddPaymentType addPaymenType = [(HomeMainViewModel *)self.mainViewModel addPaymentType];
    self.tfName.enabled = NO;
    self.tfName.text = [UserInfoManager sharedManager].realName;
    if (addPaymenType == AddPaymentTypeAlipay) {
        //支付宝
        self.qrCodeView.hidden = NO;
        self.lbAccountTitle.text = NSLocalizedString(@"账号", nil);
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入您本人支付宝账号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    } else if (addPaymenType == AddPaymentTypePayPal) {
        //Paypal
        self.qrCodeView.hidden = YES;
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入您本人PayPal账号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    } else if (addPaymenType == AddPaymentTypeWeChat) {
        //微信
        self.qrCodeView.hidden = NO;
        self.lbTitle.text = NSLocalizedString(@"添加微信收款二维码", nil);
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入微信号（手机号）", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    } else {
        //银行卡
        self.qrCodeView.hidden = YES;
        self.bankNameView.hidden = NO;
        self.bankAddressView.hidden = NO;
        self.lbAccountTitle.text = NSLocalizedString(@"银行卡号", nil);
        self.tfAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入银行卡号", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        self.tfName.enabled = YES;
        self.tfName.text = @"";
    }
}

- (void)updateImageView {
    NSString *qrCodeString = [(HomeMainViewModel *)self.mainViewModel frontImg];
    if (![NSString isEmpty:qrCodeString]) {
        [self.imgViewQRCode setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, qrCodeString]]];
    }
}

#pragma mark - Setter & Getter
- (UIView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _qrCodeView.hidden = YES;
        self.lbTitle = [UILabel labelWithText:NSLocalizedString(@"添加支付宝收款二维码", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
        [_qrCodeView addSubview:self.lbTitle];
        [self.lbTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(40);
            make.left.equalTo(15);
        }];
        
        self.lbOptional = [UILabel labelWithText:NSLocalizedString(@"选填", nil) textColor:kRGB(0, 102, 237) font:kFont(14)];
        [_qrCodeView addSubview:self.lbOptional];
        [self.lbOptional makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.lbTitle);
            make.right.equalTo(-15);
        }];
        
        self.imgViewQRCode = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"sctp"]];
        self.imgViewQRCode.userInteractionEnabled = YES;
        [self.imgViewQRCode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadQRCode)]];
        [_qrCodeView addSubview:self.imgViewQRCode];
        [self.imgViewQRCode makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(100);
            make.top.equalTo(self.lbTitle.mas_bottom).offset(15);
            make.left.equalTo(15);
        }];
    }
    return _qrCodeView;
}

@end
