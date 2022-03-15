//
//  PersonalCenterViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "AboutUsViewController.h"
#import "LanguageViewController.h"
#import "ProtocolViewController.h"
#import "InvitationLinkViewController.h"
#import "AuthenticationViewController.h"
#import "SecuritySettingsViewController.h"

#import "PersonalCenterMainView.h"

#import "UserModel.h"
#import "HomeMainViewModel.h"

@interface PersonalCenterViewController ()<PersonalCenterMainViewDelegate>
@property (nonatomic, strong) PersonalCenterMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@end

@implementation PersonalCenterViewController

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
    //用户信息
    [self.mainViewModel fetchUserInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

- (void)fetchServiceData {
    //客服信息
    WeakSelf
    [self.mainViewModel fetchServiceWithResult:^(BOOL success) {
        if (success) {
            if (![NSString isEmpty:weakSelf.mainViewModel.serviceString]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.mainViewModel.serviceString]];
            }
        }
    }];
}

#pragma mark - PersonalCenterMainViewDelegate
- (void)tableView:(UITableView *)tableView didSelectedIndex:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            //关于我们
            AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        } else if (indexPath.row == 0) {
            //联系客服
            [self fetchServiceData];
        } else if (indexPath.row == 2) {
            //白皮书
            ProtocolViewController *protocolVC = [[ProtocolViewController alloc] init];
            protocolVC.type = @"white";
            [self.navigationController pushViewController:protocolVC animated:YES];
        }
    } else if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //安全设置
            SecuritySettingsViewController *securityVC = [[SecuritySettingsViewController alloc] init];
            [self.navigationController pushViewController:securityVC animated:YES];
        } else if (indexPath.row == 1) {
            //身份验证
            if ([self.mainViewModel.userModel.realStatus isEqualToString:@"0"]) {
                AuthenticationViewController *authVC = [[AuthenticationViewController alloc] init];
                [self.navigationController pushViewController:authVC animated:YES];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //邀请链接
            InvitationLinkViewController *inviteLinkVC = [[InvitationLinkViewController alloc] init];
            [self.navigationController pushViewController:inviteLinkVC animated:YES];
        } else if (indexPath.row == 1) {
            //语言
            LanguageViewController *languageVC = [[LanguageViewController alloc] init];
            [self.navigationController pushViewController:languageVC animated:YES];
        }
    }
}

- (void)tableViewWithLogout:(UITableView *)tableView {
    //退出登录
    [self.mainViewModel fetchLogoutWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"退出成功", nil) completionHandle:^{
                [[AppDelegate sharedDelegate] logout];
            }];
        }
    }];
}

#pragma mark Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"个人中心", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (PersonalCenterMainView *)mainView {
    if (!_mainView) {
        _mainView = [[PersonalCenterMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
