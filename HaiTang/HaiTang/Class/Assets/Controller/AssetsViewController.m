//
//  AssetsViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AssetsViewController.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "TransferViewController.h"
#import "USDTAssetsViewController.h"
#import "RecordsViewController.h"

#import "AssetsMainView.h"

#import "AssetsMainViewModel.h"

@interface AssetsViewController ()<AssetsMainViewDelegate>
@property (nonatomic, strong) AssetsMainView *mainView;
@property (nonatomic, strong) AssetsMainViewModel *mainViewModel;

@end

@implementation AssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchAssetsInfoData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAssetsInfoData];
}

#pragma mark - Request Data
- (void)fetchAssetsInfoData {
    [self.mainViewModel fetchAssetsInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - AssetsMainViewDelegate
- (void)tableViewWithCheckRecharge:(UIButton *)btn {
    //充币
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    rechargeVC.symbol = @"USDT-ERC20";
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)tableViewWithWithdraw:(UITableView *)tableView {
    //提币
    WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
    withdrawVC.symbol = @"USDT";
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

- (void)tableViewWithTransfer:(UITableView *)tableView {
    //划转
    TransferViewController *transferVC = [[TransferViewController alloc] init];
    transferVC.symbol = @"USDT";
    [self.navigationController pushViewController:transferVC animated:YES];
}

- (void)tableView:(UITableView *)tableView checkAssetsDetail:(NSString *)list_id {
    //资产详情
    USDTAssetsViewController *assetsVC = [[USDTAssetsViewController alloc] init];
    assetsVC.assetsType = self.mainViewModel.usdtAssetsType;
    assetsVC.list_id = list_id;
    [self.navigationController pushViewController:assetsVC animated:YES];
}

- (void)tableViewSwitchAssets:(UITableView *)tableView {
    //切换资产
    [self fetchAssetsInfoData];
}

- (void)tableViewWithCheckRecord:(UITableView *)tableView {
    //记录
    NSInteger index = self.mainViewModel.usdtAssetsType + 3;
    RecordsViewController *recordVC = [[RecordsViewController alloc] init];
    recordVC.recordType = index;
    recordVC.symbols = @"";
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.backgroundColor = kRGB(248, 248, 248);
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"个人资产", nil) textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
    self.navBar.navLeftView = lbTitle;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (AssetsMainView *)mainView {
    if (!_mainView) {
        _mainView = [[AssetsMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (AssetsMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[AssetsMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
