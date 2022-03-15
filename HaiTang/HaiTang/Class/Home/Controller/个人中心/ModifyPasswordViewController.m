//
//  ModifyPasswordViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ModifyPasswordViewController.h"

#import "ModifyPasswordMainView.h"

#import "HomeMainViewModel.h"

@interface ModifyPasswordViewController ()<ModifyPasswordMainViewDelegate>
@property (nonatomic, strong) ModifyPasswordMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

#pragma mark - ModifyPasswordMainViewDelegate
- (void)mainViewWithUpdateNewPassword:(NSString *)msgOrOldPassword {
    //修改登录密码或资产密码
    [self.mainViewModel fetchUpdatePassword:msgOrOldPassword result:^(BOOL success) {
        if (success) {
            if (self.modifyType == ModifyTypeLoginPassword) {
                [JYToastUtils showLongWithStatus:NSLocalizedString(@"修改密码成功", nil) completionHandle:^{
                    [[AppDelegate sharedDelegate] logout];
                }];
            } else if (self.modifyType == ModifyTypeAssetsPassword) {
                //资产密码
                [JYToastUtils showLongWithStatus:NSLocalizedString(@"设置成功", nil) completionHandle:^{
                    [self popViewController];
                }];
            }
        }
    }];
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

- (void)mainViewWithSetNickName:(NSString *)nickName {
    //设置昵称
    [self.mainViewModel fetchNickName:nickName result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"设置成功", nil) completionHandle:^{
                [self popViewController];
            }];
        }
    }];
}

#pragma mark - Super Class
- (void)setupNavigation {
    NSString *title = @"修改登录密码";
    if (self.modifyType == ModifyTypeNickName) {
        title = @"法币交易昵称";
    } else if (self.modifyType == ModifyTypeAssetsPassword) {
        title = @"设置资产密码";
    }
    self.navBar.title = NSLocalizedString(title, nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}


#pragma mark - Setter & Getter
- (ModifyPasswordMainView *)mainView {
    if (!_mainView) {
        _mainView = [[ModifyPasswordMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (HomeMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[HomeMainViewModel alloc] initWithModifyType:self.modifyType];
    }
    return _mainViewModel;
}

@end
