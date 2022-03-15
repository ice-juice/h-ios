//
//  RegisterViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RegisterViewController.h"
#import "ProtocolViewController.h"
#import "PhoneCodeViewController.h"
#import "LanguageViewController.h"

#import "RegisterMainView.h"

#import "LoginMainViewModel.h"

@interface RegisterViewController ()<RegisterMainViewDelegate>
@property (nonatomic, strong) RegisterMainView *mainView;
@property (nonatomic, strong) LoginMainViewModel *mainViewModel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - RegisterMainViewDelegate
- (void)mainViewWithCheckProtocol:(NSString *)protocolType {
    ProtocolViewController *protocolVC = [[ProtocolViewController alloc] init];
    protocolVC.type = protocolType;
    [self.navigationController pushViewController:protocolVC animated:YES];
}

- (void)mainViewWithLogin {
    //登录
    [[AppDelegate sharedDelegate] showLoginPage];
}

- (void)mainViewWithSendVerifyCode {
    //获取验证码
    [self.mainViewModel sendVerifyCodeCountDown:^(NSString * _Nonnull countDown, BOOL isEnd) {
        [self.mainView updateCountDown:countDown isEnd:isEnd];
    } result:^(BOOL success) {
        if (success) {
            [JYToastUtils showWithStatus:NSLocalizedString(@"发送验证码成功", nil) duration:2];
        } else {
            [self.mainView updateCountDown:NSLocalizedString(@"重新发送", nil) isEnd:YES];
        }
    }];
}

- (void)mainViewWithRegister:(NSString *)verifyCode {
    //注册
    [self.mainViewModel fetchRegisterWith:verifyCode result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"注册成功", nil) completionHandle:^{
                [self popViewController];
            }];
        }
    }];
}

- (void)selectPhoneCode {
    //选择手机区号
    PhoneCodeViewController *codeVC = [[PhoneCodeViewController alloc] init];
    WeakSelf
    [codeVC setOnSelectPhoneCodeBlock:^(NSString * _Nonnull phoneCode) {
        weakSelf.mainViewModel.phoneCode = phoneCode;
        [weakSelf.mainView.btnAreaCode setTitle:[NSString stringWithFormat:@"+%@", phoneCode] forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:codeVC animated:YES];
}

#pragma mark - Event Response
- (void)onBtnSelectLanguageEvent:(UIButton *)btn {
    //语言
    LanguageViewController *languageVC = [[LanguageViewController alloc] init];
    [self.navigationController pushViewController:languageVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    UIButton *btnLanguage = [UIButton buttonWithTitle:NSLocalizedString(@"语言", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kBoldFont(18) target:self selector:@selector(onBtnSelectLanguageEvent:)];
    btnLanguage.frame = CGRectMake(0, 0, 100, 30);
    [btnLanguage setImage:[StatusHelper imageNamed:@"xiala"] forState:UIControlStateNormal];
    [btnLanguage setTitleLeftSpace:5];
    self.navBar.navRightView = btnLanguage;
    self.navBar.hiddenReturn = YES;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (RegisterMainView *)mainView {
    if (!_mainView) {
        _mainView = [[RegisterMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (LoginMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[LoginMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
