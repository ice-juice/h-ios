//
//  SecuritySettingsViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SecuritySettingsViewController.h"
#import "ModifyPasswordViewController.h"
#import "BindViewController.h"
#import "CollectionSettingsViewController.h"

#import "SecuritySettingsMainView.h"

#import "HomeMainViewModel.h"

@interface SecuritySettingsViewController ()<SecuritySettingsMainViewDelegate>
@property (nonatomic, strong) SecuritySettingsMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@end

@implementation SecuritySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchUserInfoData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchUserInfoData];
}

#pragma mark - Request Data
- (void)fetchUserInfoData {
    [self.mainViewModel fetchUserInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - SecuritySettingsMainViewDelegate
- (void)tableView:(UITableView *)tableView didSelectedIndex:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //登录密码
            ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc] init];
            modifyPasswordVC.modifyType = ModifyTypeLoginPassword;
            [self.navigationController pushViewController:modifyPasswordVC animated:YES];
        } else if (indexPath.row == 1) {
            //手机验证
            BindViewController *bindPhoneVC = [[BindViewController alloc] init];
            bindPhoneVC.bindType = BindTypePhone;
            [self.navigationController pushViewController:bindPhoneVC animated:YES];
        } else if (indexPath.row == 2) {
            //邮箱验证
            BindViewController *bindEmailVC = [[BindViewController alloc] init];
            bindEmailVC.bindType = BindTypeEmail;
            [self.navigationController pushViewController:bindEmailVC animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //法币收款方式
            CollectionSettingsViewController *collectionVC = [[CollectionSettingsViewController alloc] init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        } else if (indexPath.row == 1) {
            //法币交易昵称
            ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc] init];
            modifyPasswordVC.modifyType = ModifyTypeNickName;
            [self.navigationController pushViewController:modifyPasswordVC animated:YES];
        } else {
            //资产密码
            ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc] init];
            modifyPasswordVC.modifyType = ModifyTypeAssetsPassword;
            [self.navigationController pushViewController:modifyPasswordVC animated:YES];
        }
    }
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"安全设置", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (SecuritySettingsMainView *)mainView {
    if (!_mainView) {
        _mainView = [[SecuritySettingsMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (HomeMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[HomeMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
