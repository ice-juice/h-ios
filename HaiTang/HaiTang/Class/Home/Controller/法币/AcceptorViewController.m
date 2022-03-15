//
//  AcceptorViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AcceptorViewController.h"
#import "MyDepositViewController.h"
#import "MyPendingOrderViewController.h"
#import "ModifyPasswordViewController.h"
#import "PendingOrderListViewController.h"

#import "AcceptorMainView.h"
#import "NoAcceptorMainView.h"

#import "AcceptorModel.h"
#import "FiatMainViewModel.h"

@interface AcceptorViewController ()<AcceptorMainViewDelegate, NoAcceptorMainViewDelegate>
@property (nonatomic, strong) AcceptorMainView *mainView;
@property (nonatomic, strong) NoAcceptorMainView *noMainView;   //未成为承兑商

@property (nonatomic, strong) FiatMainViewModel *mainViewModel;

@end

@implementation AcceptorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAcceptorMarginInfoData];
}

#pragma mark - Request Data
- (void)fetchAcceptorMarginInfoData {
    WeakSelf
    [self.mainViewModel fetchAcceptorMarginInfoWithResult:^(BOOL success) {
        if (success) {
            if ([weakSelf.mainViewModel.acceptorModel.haveAppeal isEqualToString:@"N"]) {
                //不是承兑商
                weakSelf.noMainView.hidden = NO;
                weakSelf.mainView.hidden = YES;
                [weakSelf.noMainView updateView];
            } else {
                //承兑商
                weakSelf.mainView.hidden = NO;
                weakSelf.noMainView.hidden = YES;
                [weakSelf.mainView updateView];
                
            }
        }
    }];
}

#pragma mark - AcceptorMainViewDelegate
- (void)tableView:(UITableView *)tableView didSelectedIndex:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //我要挂单
        if ([self.mainViewModel.acceptorModel.deposit isEqualToString:@"0"] ||
            [self.mainViewModel.acceptorModel.deposit isEqualToString:@"1"] ||
            [self.mainViewModel.acceptorModel.deposit isEqualToString:@"5"]) {
            PendingOrderListViewController *pendingOrderVC = [[PendingOrderListViewController alloc] init];
            [self.navigationController pushViewController:pendingOrderVC animated:YES];
        }
    } else if (indexPath.row == 1) {
        //我的挂单购买
        MyPendingOrderViewController *pendingOrderVC = [[MyPendingOrderViewController alloc] init];
        pendingOrderVC.orderType = 0;
        [self.navigationController pushViewController:pendingOrderVC animated:YES];
    } else if (indexPath.row == 2) {
        //我的挂单出售
        MyPendingOrderViewController *pendingOrderVC = [[MyPendingOrderViewController alloc] init];
        pendingOrderVC.orderType = 1;
        [self.navigationController pushViewController:pendingOrderVC animated:YES];
    } else if (indexPath.row == 3) {
        if ([self.mainViewModel.acceptorModel.deposit isEqualToString:@"0"] ||
            [self.mainViewModel.acceptorModel.deposit isEqualToString:@"1"] ||
            [self.mainViewModel.acceptorModel.deposit isEqualToString:@"3"]) {
            //我的保证金
            MyDepositViewController *depositVC = [[MyDepositViewController alloc] init];
            [self.navigationController pushViewController:depositVC animated:YES];
        } else {
            self.noMainView.hidden = NO;
            self.mainView.hidden = YES;
            [self.noMainView updateView];
        }
    }
}

#pragma mark - NoAcceptorMainViewDelegate
- (void)applyToBecomeAnAcceptor {
    //申请成为承兑商
    [self.mainViewModel fetchApplyToBecomeAnAcceptorWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"请求成功", nil) completionHandle:^{
                [self popViewController];
            }];
        }
    }];
}

- (void)onForgetAssetsPassword {
    //忘记资产密码
    ModifyPasswordViewController *passwordVC = [[ModifyPasswordViewController alloc] init];
    passwordVC.modifyType = ModifyTypeAssetsPassword;
    [self.navigationController pushViewController:passwordVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"承兑商", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    [self.view addSubview:self.noMainView];
    [self.noMainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (AcceptorMainView *)mainView {
    if (!_mainView) {
        _mainView = [[AcceptorMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
        _mainView.hidden = YES;
    }
    return _mainView;
}

- (NoAcceptorMainView *)noMainView {
    if (!_noMainView) {
        _noMainView = [[NoAcceptorMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
        _noMainView.hidden = YES;
    }
    return _noMainView;
}

- (FiatMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[FiatMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
