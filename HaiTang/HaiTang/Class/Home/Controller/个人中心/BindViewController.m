//
//  BindViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BindViewController.h"
#import "PhoneCodeViewController.h"

#import "BindMainView.h"

#import "HomeMainViewModel.h"

@interface BindViewController ()<BindMainViewDelegate>
@property (nonatomic, strong) BindMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

#pragma mark - BindMainViewDelegate
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

- (void)mainViewWithVerificationCode:(NSString *)verifyCode {
    //验证验证码
    [self.mainViewModel fetchVerificationCode:verifyCode result:^(BOOL success) {
        if (success) {
            [self.mainView updateVerifyCodeResult];
        }
    }];
}

- (void)mainViewWithBinding:(NSString *)verifyCode {
    //账号绑定
    [self.mainViewModel fetchBindingAccount:verifyCode result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"绑定成功", nil) completionHandle:^{
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
        weakSelf.mainViewModel.code = phoneCode;
        [weakSelf.mainView.btnAreaCode setTitle:[NSString stringWithFormat:@"+%@", phoneCode] forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:codeVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    NSString *title = self.bindType == BindTypePhone ? NSLocalizedString(@"绑定手机验证", nil) : NSLocalizedString(@"绑定邮箱验证", nil);
    self.navBar.title = title;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (BindMainView *)mainView {
    if (!_mainView) {
        _mainView = [[BindMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (HomeMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[HomeMainViewModel alloc] initWithBindType:self.bindType];
    }
    return _mainViewModel;
}

@end
