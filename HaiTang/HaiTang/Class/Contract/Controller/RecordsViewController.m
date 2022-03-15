//
//  RecordsViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RecordsViewController.h"

#import "RecordsMainView.h"

#import "ContractMainViewModel.h"

@interface RecordsViewController ()<RecordsMainViewDelegate>
@property (nonatomic, strong) RecordsMainView *mainView;
@property (nonatomic, strong) ContractMainViewModel *mainViewModel;

@end

@implementation RecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateHeaderView];
    [self fetchRecordsData];
    [self fetchTypeData];
}

#pragma mark - Request Data
- (void)fetchRecordsData {
    if (self.recordType == RecordTypeRecharge || self.recordType == RecordTypeWithdraw) {
        //充币记录、提币记录
        [self.mainViewModel fetchRechargeOrWithdrawRecordWithResult:^(BOOL success, BOOL loadMore) {
            if (success) {
                [self.mainView updateView];
            }
            [self.mainView showFooterView:loadMore];
        }];
        
    } else if (self.recordType == RecordTypeCloseing) {
        //平仓记录
        [self.mainViewModel fetchCloseingRecordsWithResult:^(BOOL success, BOOL loadMore) {
            if (success) {
                [self.mainView updateView];
            }
            [self.mainView showFooterView:loadMore];
        }];
    } else if (self.recordType == RecordTypeDeal) {
        //成交记录
        [self.mainViewModel fetchCurrencyRecordsWithResult:^(BOOL success, BOOL loadMore) {
            if (success) {
                [self.mainView updateView];
            }
            [self.mainView showFooterView:loadMore];
        }];
    } else {
        [self.mainViewModel fetchRecordsWithResult:^(BOOL success, BOOL loadMore) {
            //流水记录
            if (success) {
                [self.mainView updateView];
            }
            [self.mainView showFooterView:loadMore];
        }];
    }
}

- (void)fetchTypeData {
    //获取类型
    [self.mainViewModel fetchTypeWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateTypeView];
        }
    }];
}

#pragma mark - RecordsMainViewDelegate
- (void)pullUpHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo ++;
    [self fetchRecordsData];
}

- (void)pullDownHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo = 1;
    [self fetchRecordsData];
}

- (void)tableViewWithFilter:(UITableView *)tableView {
    //筛选
    self.mainViewModel.pageNo = 1;
    [self fetchRecordsData];
}

#pragma mark - Super Class
- (void)setupNavigation {
    NSString *title = @"";
    if (self.recordType == RecordTypeCloseing) {
        title = @"平仓记录";
    } else if (self.recordType == RecordTypeCoinAssets) {
        title = @"币币资产记录";
    } else if (self.recordType == RecordTypeDeal) {
        title = @"成交记录";
    } else if (self.recordType == RecordTypeRecharge) {
        title = @"充币记录";
    } else if (self.recordType == RecordTypeWithdraw) {
        title = @"提币记录";
    } else if (self.recordType == RecordTypeFiatAssets) {
        title = @"法币资产记录";
    } else if (self.recordType == RecordTypeWalletAssets) {
        title = @"钱包资产记录";
    } else if (self.recordType == RecordTypeContractAssets) {
        title = @"合约资产记录";
    }
    self.navBar.title = NSLocalizedString(title, nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (RecordsMainView *)mainView {
    if (!_mainView) {
        _mainView = [[RecordsMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (ContractMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[ContractMainViewModel alloc] initWithRecordType:self.recordType symbols:self.symbols];
    }
    return _mainViewModel;
}

@end
