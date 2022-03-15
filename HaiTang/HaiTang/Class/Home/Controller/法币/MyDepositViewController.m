//
//  MyDepositViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "MyDepositViewController.h"
#import "ModifyPasswordViewController.h"

#import "MyDepositMainView.h"

#import "FiatMainViewModel.h"

@interface MyDepositViewController ()<MyDepositMainViewDelegate>
@property (nonatomic, strong) MyDepositMainView *mainView;
@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation MyDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.depositStatus == MyDepositStatusMakeUp) {
        //补缴
        [self fetchMakeUpDepositData];
    } else {
        [self fetchMyDepositData];
    }
}

#pragma mark - Request Data
- (void)fetchMyDepositData {
    //保证金信息情况
    [self.mainViewModel fetchAcceptorMarginInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

- (void)fetchMakeUpDepositData {
    //补缴押金页面信息
    [self.mainViewModel fetchMakeUpDepositWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - MyDepositMainViewDelegate
- (void)onRefundDeposit {
    //退还保证金
    [self.mainViewModel fetchRefundDepositWithResult:^(BOOL success) {
        if (success) {
            [self fetchMyDepositData];
        }
    }];
}

- (void)onPayBack {
    //补缴保证金
    MyDepositViewController *depositVC = [[MyDepositViewController alloc] init];
    depositVC.depositStatus = MyDepositStatusMakeUp;
    [self.navigationController pushViewController:depositVC animated:YES];
}

- (void)onSubmitPayBackWithPassword:(NSString *)password {
    //提交补缴
    [self.mainViewModel fetchSubmitDepositWithPassword:password result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"操作成功", nil) completionHandle:^{
//                self.mainViewModel.depositStatus = MyDepositStatusNormal;
//                [self fetchMyDepositData];
                if (self.navigationController.viewControllers.count >= 2) {
                    UIViewController *listViewController = self.navigationController.viewControllers[1];
                    [self.navigationController popToViewController:listViewController animated:YES];
                }
            }];
        }
    }];
}

- (void)onForgetPassword {
    //忘记密码
    ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc] init];
    modifyPasswordVC.modifyType = ModifyTypeAssetsPassword;
    [self.navigationController pushViewController:modifyPasswordVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"我的保证金", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (MyDepositMainView *)mainView {
    if (!_mainView) {
        _mainView = [[MyDepositMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (FiatMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[FiatMainViewModel alloc] initWithDepositStatus:self.depositStatus];
    }
    return _mainViewModel;
}

@end
