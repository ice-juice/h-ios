//
//  ChangePasswordViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "ChangePasswordMainView.h"

#import "LoginMainViewModel.h"

@interface ChangePasswordViewController ()<ChangePasswordMainViewDelegate>
@property (nonatomic, strong) ChangePasswordMainView *mainView;
@property (nonatomic, strong) LoginMainViewModel *mainViewModel;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - ChangePasswordMainViewDelegate
- (void)mainViewWithUpdatePassword {
    [self.mainViewModel fetchUpdatePassword:self.account verifyCode:self.verifyCode result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"修改密码成功", nil) completionHandle:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
}

#pragma mark - Super Class
- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (ChangePasswordMainView *)mainView {
    if (!_mainView) {
        _mainView = [[ChangePasswordMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
