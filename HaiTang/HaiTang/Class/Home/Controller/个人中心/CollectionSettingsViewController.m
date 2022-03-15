//
//  CollectionSettingsViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CollectionSettingsViewController.h"
#import "PaymentMethodViewController.h"
#import "AuthenticationViewController.h"

#import "MarginPopupView.h"
#import "CollectionSettingsMainView.h"

#import "UserInfoManager.h"
#import "HomeMainViewModel.h"

@interface CollectionSettingsViewController ()<CollectionSettingsMainViewDelegate>
@property (nonatomic, strong) CollectionSettingsMainView *mainView;
@property (nonatomic, strong) MarginPopupView *popupView;

@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@end

@implementation CollectionSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchCollectionSettingsData];
}

#pragma mark - Request Data
- (void)fetchCollectionSettingsData {
    //收款方式列表
    [self.mainViewModel fetchCollectionSettingsWithResult:^(BOOL success, BOOL loadMore) {
        if (success) {
            [self.mainView updateView];
        }
        [self.mainView showFooterView:loadMore];
    }];
}

#pragma mark - CollectionSettingsMainViewDelegate
- (void)tableViewWithAddPayment:(UITableView *)tableView {
    [self fetchIsRealName];
}

- (void)tableView:(UITableView *)tableView deletePayment:(NSString *)paymentId {
    //删除收款方式
    [self.mainViewModel fetchDeletePayment:paymentId result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"删除成功", nil) completionHandle:^{
                [self fetchCollectionSettingsData];
            }];
        }
    }];
}

#pragma mark - Event Response
- (void)onBtnWithAddEvent:(UIButton *)btn {
    [self fetchIsRealName];
}

- (void)fetchIsRealName {
    //(判断有无实名认证)
    if ([[UserInfoManager sharedManager].realStatus isEqualToString:@"1"]) {
        //已认证-添加收款方式
        PaymentMethodViewController *paymentVC = [[PaymentMethodViewController alloc] init];
        [self.navigationController pushViewController:paymentVC animated:YES];
        
    } else if ([[UserInfoManager sharedManager].realStatus isEqualToString:@"0"]) {
        //未认证
        [self.popupView showViewWithPopupType:PopupTypeAuthentication];
        
    } else {
        //审核中
        [JYToastUtils showWithStatus:NSLocalizedString(@"实名认证审核中", nil) duration:2];
    }
}

- (void)fetchAuthentication {
    //实名认证
    AuthenticationViewController *authVC = [[AuthenticationViewController alloc] init];
    [self.navigationController pushViewController:authVC animated:YES];
}

#pragma mark - Setter & Getter
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"收款设置", nil);
    
    UIButton *btnAdd = [UIButton buttonWithImageName:@"sksz-tj" highlightedImageName:@"sksz-tj" target:self selector:@selector(onBtnWithAddEvent:)];
    self.navBar.navRightView = btnAdd;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (CollectionSettingsMainView *)mainView {
    if (!_mainView) {
        _mainView = [[CollectionSettingsMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (MarginPopupView *)popupView {
    if (!_popupView) {
        _popupView = [[MarginPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_popupView setOnBtnWithYesBlock:^{
            [weakSelf fetchAuthentication];
        }];
    }
    return _popupView;
}

- (HomeMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[HomeMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
