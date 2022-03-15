//
//  ForgetPasswordViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ChangePasswordViewController.h"

#import "ForgetPasswordMainView.h"

#import "LoginMainViewModel.h"

@interface ForgetPasswordViewController ()<ForgetPasswordMainViewDelegate>
@property (nonatomic, strong) ForgetPasswordMainView *mainView;
@property (nonatomic, strong) LoginMainViewModel *mainViewModel;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - ForgetPasswordMainViewDelegate
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

- (void)mainViewWithNext:(NSString *)verifyCode {
    //修改密码
    ChangePasswordViewController *changeVC = [[ChangePasswordViewController alloc] init];
    changeVC.account = self.mainViewModel.account;
    changeVC.verifyCode = verifyCode;
    [self.navigationController pushViewController:changeVC animated:YES];
}

#pragma mark - Super Class
- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (ForgetPasswordMainView *)mainView {
    if (!_mainView) {
        _mainView = [[ForgetPasswordMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
