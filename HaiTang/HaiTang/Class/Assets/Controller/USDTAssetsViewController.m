//
//  USDTAssetsViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "USDTAssetsViewController.h"
#import "RecordsViewController.h"
#import "WithdrawViewController.h"
#import "TransferViewController.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"

#import "USDTAssetsMainView.h"

#import "AssetsModel.h"
#import "AssetsMainViewModel.h"

@interface USDTAssetsViewController ()<USDTAssetsMainViewDelegate>
@property (nonatomic, strong) USDTAssetsMainView *mainView;
@property (nonatomic, strong) AssetsMainViewModel *mainViewModel;

@end

@implementation USDTAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchAssetsDetailData];
}

#pragma mark - Request Data
- (void)fetchAssetsDetailData {
    [self.mainViewModel fetchAssetsDetailWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
            [self updateNavigation];
        }
    }];
}

#pragma mark - USDTAssetsMainViewDelegate
- (void)tableViewWithCheckRecharge:(UITableView *)tableView {
    //充币
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    rechargeVC.symbol = self.mainViewModel.assetsDetailModel.type;
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)tableViewWithCheckWithdraw:(UITableView *)tableView {
    //提币
    WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
    withdrawVC.symbol = self.mainViewModel.assetsDetailModel.type;
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

- (void)tableViewWithCheckTransfer:(UITableView *)tableView {
    //划转
    TransferViewController *transferVC = [[TransferViewController alloc] init];
    transferVC.symbol = self.mainViewModel.assetsDetailModel.type;
    [self.navigationController pushViewController:transferVC animated:YES];
}

- (void)tableViewWithCheckRecord:(UITableView *)tableView {
    //记录
    RecordsViewController *recordVC = [[RecordsViewController alloc] init];
    NSInteger index = self.assetsType + 3;
    recordVC.recordType = index;
    recordVC.symbols = self.mainViewModel.assetsDetailModel.type;
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - Super Class
- (void)updateNavigation {
    NSString *title = @"";
    if (self.assetsType == USDTAssetsTypeCoin) {
        title = [NSString stringWithFormat:@"%@%@", self.mainViewModel.assetsDetailModel.type, NSLocalizedString(@"币币资产", nil)];
    } else if (self.assetsType == USDTAssetsTypeFiat) {
        title = [NSString stringWithFormat:@"%@%@", self.mainViewModel.assetsDetailModel.type, NSLocalizedString(@"法币资产", nil)];
    } else if (self.assetsType == USDTAssetsTypeContract) {
        title = [NSString stringWithFormat:@"%@%@", self.mainViewModel.assetsDetailModel.type, NSLocalizedString(@"合约资产", nil)];
    } else if (self.assetsType == USDTAssetsTypeWallet) {
        title = [NSString stringWithFormat:@"%@%@", self.mainViewModel.assetsDetailModel.type, NSLocalizedString(@"钱包资产", nil)];
    }
    self.navBar.title = title;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (USDTAssetsMainView *)mainView {
    if (!_mainView) {
        _mainView = [[USDTAssetsMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (AssetsMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[AssetsMainViewModel alloc] initWithUSDTAssetsType:self.assetsType list_id:self.list_id];
    }
    return _mainViewModel;
}

@end
