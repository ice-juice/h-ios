//
//  EnterFundPasswordView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "EnterFundPasswordView.h"

@interface EnterFundPasswordView ()
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *tfPassword;

@end

@implementation EnterFundPasswordView
#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 400, self.frame.size.width, 278)];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 278, self.frame.size.width, 278)];
}

- (void)keyboardDidHide:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 278, self.frame.size.width, 278)];
}

#pragma mark - Event Response
- (void)onBtnWithCloseEvent:(UIButton *)btn {
    [self closeView];
}

- (void)onBtnWithSureEvent:(UIButton *)btn {
    if ([NSString isEmpty:self.tfPassword.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入资金密码", nil) duration:2];
    }
    if (self.onBtnSubmitPasswordBlock) {
        self.onBtnSubmitPasswordBlock(self.tfPassword.text);
    }
    [self closeView];
}

- (void)onBtnWithForgetPasswordEvent:(UIButton *)btn {
    //忘记密码
    [self closeView];

    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.onBtnForgetPasswordBlock) {
            weakSelf.onBtnForgetPasswordBlock();
        }
    });
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
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(278);
    }];
    
    self.lbTitle = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:20]];
    [self.contentView addSubview:self.lbTitle];
    [self.lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(24);
        make.left.equalTo(15);
    }];
    
    UIButton *btnClose = [UIButton buttonWithImageName:@"belvedere_ic_close" highlightedImageName:@"belvedere_ic_close" target:self selector:@selector(onBtnWithCloseEvent:)];
    [self.contentView addSubview:btnClose];
    [btnClose makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(36);
        make.top.equalTo(20);
        make.right.equalTo(-15);
    }];
    
    UILabel *lbSubTitle = [UILabel labelWithText:NSLocalizedString(@"为确保本次交易为账户本人操作，请您输入资金密码", nil) textColor:kRedColor font:kBoldFont(12)];
    [self.contentView addSubview:lbSubTitle];
    [lbSubTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).offset(8);
        make.left.equalTo(15);
    }];
    
    self.tfPassword = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入资金密码", nil) hasLine:YES];
    self.tfPassword.keyboardType = UIKeyboardTypeNumberPad;
    self.tfPassword.secureTextEntry = YES;
    [self.contentView addSubview:self.tfPassword];
    [self.tfPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbSubTitle.mas_bottom).offset(17);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UIButton *btnForget = [UIButton buttonWithTitle:NSLocalizedString(@"忘记资金密码？", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithForgetPasswordEvent:)];
    [self.contentView addSubview:btnForget];
    [btnForget makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfPassword.mas_bottom).offset(10);
        make.right.equalTo(-19);
    }];
    
    UIButton *btnSure = [UIButton buttonWithTitle:NSLocalizedString(@"确认", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSureEvent:)];
    btnSure.backgroundColor = kRGB(0, 102, 237);
    btnSure.layer.cornerRadius = 4;
    [self.contentView addSubview:btnSure];
    [btnSure makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-49);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)showViewWithTitle:(NSString *)title {
    self.lbTitle.text = NSLocalizedString(title, nil);
    self.tfPassword.text = @"";
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 278)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, kScreenHeight - 278, kScreenWidth, 278)];
    }];
}

- (void)closeView {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 278)];
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
