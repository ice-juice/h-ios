//
//  TransferViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "TransferViewController.h"
#import "SelectSymbolViewController.h"

#import "TransferMainView.h"

#import "AssetsMainViewModel.h"

@interface TransferViewController ()<TransferMainViewDelegate>
@property (nonatomic, strong) TransferMainView *mainView;
@property (nonatomic, strong) AssetsMainViewModel *mainViewModel;


@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchTransferInfoData];
}

#pragma mark - Request Data
- (void)fetchTransferInfoData {
    //资产划转信息
    [self.mainViewModel fetchTransferInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - TransferMainViewDelegate
- (void)mainViewWithSelectSymbol:(NSString *)symbol {
    //选择币种
    SelectSymbolViewController *selectSymbolVC = [[SelectSymbolViewController alloc] init];
    selectSymbolVC.symbol = symbol;
    selectSymbolVC.type = @"FLOW";
    WeakSelf
    [selectSymbolVC setOnSelectedSymbolBlock:^(NSString * _Nonnull symbol) {
        //选择币种
        weakSelf.mainViewModel.symbol = symbol;
        weakSelf.mainViewModel.from = @"钱包账户";
        weakSelf.mainViewModel.to = @"币币账户";
        [weakSelf fetchTransferInfoData];
    }];
    [self.navigationController pushViewController:selectSymbolVC animated:YES];
}

- (void)mainViewWithTransferInfo {
    //获取划转页面信息
    [self fetchTransferInfoData];
}

- (void)mainViewWithSubmitTransfer:(NSString *)number {
    //资产划转
    [self.mainViewModel fetchSubmitTransferWith:number result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"提交成功", nil) completionHandle:^{
                [self popViewController];
            }];
        }
    }];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"资产划转", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (TransferMainView *)mainView {
    if (!_mainView) {
        _mainView = [[TransferMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (AssetsMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[AssetsMainViewModel alloc] initWithSymbol:self.symbol];
    }
    return _mainViewModel;
}

@end
