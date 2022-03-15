//
//  AboutUsViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ProtocolViewController.h"

#import "AboutUsMainView.h"

#import "HomeMainViewModel.h"

@interface AboutUsViewController ()<AboutUsMainViewDelegate>
@property (nonatomic, strong) AboutUsMainView *mainView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

#pragma mark - AboutUsMainViewDelegate
- (void)tableView:(UITableView *)tableView didSelectedIndex:(NSIndexPath *)indexPath {
    ProtocolViewController *protocolVC = [[ProtocolViewController alloc] init];
    if (indexPath.row == 0) {
        //隐私政策
        protocolVC.type = @"PRIMARY";
        [self.navigationController pushViewController:protocolVC animated:YES];
    } else if (indexPath.row == 1) {
        //服务条款
        protocolVC.type = @"SERVER_INFO";
        [self.navigationController pushViewController:protocolVC animated:YES];
    }
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"关于我们", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (AboutUsMainView *)mainView {
    if (!_mainView) {
        _mainView = [[AboutUsMainView alloc] initWithDelegate:self];
    }
    return _mainView;
}

@end
