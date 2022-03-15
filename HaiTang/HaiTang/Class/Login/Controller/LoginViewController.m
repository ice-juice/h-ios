//
//  LoginViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LanguageViewController.h"
#import "ForgetPasswordViewController.h"

#import "LoginMainView.h"

#import "LoginMainViewModel.h"

@interface LoginViewController ()<LoginMainViewDelegate>
@property (nonatomic, strong) LoginMainView *mainView;
@property (nonatomic, strong) LoginMainViewModel *mainViewModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mainView updateView];
}

#pragma mark - LoginMainViewDelegate
- (void)mainViewWithRegister {
    //注册
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)mainViewWithForgetPassword {
    //忘记密码
    ForgetPasswordViewController *forgetVC = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)mainViewWithLogin:(NSString *)account password:(NSString *)password {
    //登录
    [self.mainViewModel fetchLoginWith:account password:password result:^(BOOL success) {
        if (success) {
            [self fetchUserInfoData];
        }
    }];
}

- (void)fetchUserInfoData {
    //用户信息
    [self.mainViewModel fetchUserInfoWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"登录成功", nil) completionHandle:^{
                [[AppDelegate sharedDelegate] showMainPage];
            }];
        }
    }];
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
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (LoginMainView *)mainView {
    if (!_mainView) {
        _mainView = [[LoginMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
