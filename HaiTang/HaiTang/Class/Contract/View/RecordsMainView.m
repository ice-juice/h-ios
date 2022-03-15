//
//  RecordsMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RecordsMainView.h"
#import "CloseRecordTableCell.h"
#import "DropDownView.h"
#import "EmptyView.h"
#import "CoinTableCell.h"
#import "BaseTableViewCell.h"
#import "AssetsRecordsTableCell.h"
#import "WithdrawRecordsTableCell.h"
#import "RechargeRecordsTableCell.h"

#import "SymbolModel.h"
#import "RecordSubModel.h"
#import "ContractMainViewModel.h"

#define rowSpace (kScreenWidth - 390) / 3
@interface RecordsMainView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *btnType0;
@property (nonatomic, strong) UIButton *btnType1;
@property (nonatomic, strong) UIButton *btnType2;
@property (nonatomic, strong) DropDownView *dropDownView;
@property (nonatomic, strong) DropDownView *dropDownView1;
@property (nonatomic, strong) DropDownView *dropDownView2;

@property (nonatomic, copy) NSArray<NSString *> *arrayType0;
@property (nonatomic, copy) NSArray<NSString *> *arrayType1;
@property (nonatomic, copy) NSArray<NSString *> *arrayType2;

@end

@implementation RecordsMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(ContractMainViewModel *)self.mainViewModel arrayRecordDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    if (indexPath.section < [[(ContractMainViewModel *)self.mainViewModel arrayRecordDatas] count]) {
        RecordType recordType = [(ContractMainViewModel *)self.mainViewModel recordType];
        RecordSubModel *subModel = [(ContractMainViewModel *)self.mainViewModel arrayRecordDatas][indexPath.section];
        if (recordType == RecordTypeCloseing) {
            //平仓记录
            cell = [CloseRecordTableCell cellWithTableNibView:tableView];
        } else if (recordType == RecordTypeDeal) {
            //成交记录
            cell = [CoinTableCell cellWithTableNibView:tableView];
        } else if (recordType == RecordTypeCoinAssets ||
                   recordType == RecordTypeFiatAssets ||
                   recordType == RecordTypeContractAssets ||
                   recordType == RecordTypeWalletAssets) {
            //币币资产记录、法币资产记录、合约资产记录、钱包资产记录
            cell = [AssetsRecordsTableCell cellWithTableNibView:tableView];
        } else if (recordType == RecordTypeRecharge) {
            //充币记录
            cell = [RechargeRecordsTableCell cellWithTableNibView:tableView];
        } else if (recordType == RecordTypeWithdraw) {
            //提币记录
            cell = [WithdrawRecordsTableCell cellWithTableNibView:tableView];
        }
        [cell setViewWithModel:subModel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

#pragma mark - Event Response
- (void)onBtnWithSelectContractEvent:(UIButton *)btn {
    //合约、币种
    self.btnType0.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnType1.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.btnType2.layer.borderColor = kRGB(236, 236, 236).CGColor;
    [self.dropDownView showViewWithX:10 y:kNavBarHeight + 46 width:90 height:210];
}

- (void)onBtnWithSelectType1Event:(UIButton *)btn {
    //类型1
    self.btnType0.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.btnType1.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnType2.layer.borderColor = kRGB(236, 236, 236).CGColor;
    [self.dropDownView1 showViewWithX:100 y:kNavBarHeight + 46 width:90 height:210];
}

- (void)onBtnWithSelectType2Event:(UIButton *)btn {
    //类型2
    self.btnType0.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.btnType1.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.btnType2.layer.borderColor = kRGB(0, 102, 237).CGColor;
    [self.dropDownView2 showViewWithX:195 y:kNavBarHeight + 46 width:90 height:210];
}

- (void)onBtnWithFilterEvent:(UIButton *)btn {
    //筛选
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithFilter:)]) {
        [self.delegate performSelector:@selector(tableViewWithFilter:) withObject:self.tableView];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    [self addSubview:self.headerView];
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(63);
    }];
    
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped shouldRefresh:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 63);
    }];
    
    self.emptyView = [[EmptyView alloc] initWithSuperView:self.tableView title:NSLocalizedString(@"暂无记录", nil) imageName:@"jl-k" titleColor:kRGB(153, 153, 153)];
}

- (void)updateView {
    self.emptyView.hidden = [[(ContractMainViewModel *)self.mainViewModel arrayRecordDatas] count];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)updateHeaderView {
    RecordType recordType = [(ContractMainViewModel *)self.mainViewModel recordType];
    
    [self.btnType0 setTitleLeftSpace:2];
    if (recordType == RecordTypeDeal) {
        //成交记录
        self.tableView.rowHeight = 265;
        self.btnType0.hidden = NO;
        self.btnType1.hidden = NO;
        [self.btnType0 setTitle:NSLocalizedString(@"全部币种", nil) forState:UIControlStateNormal];
        [self.btnType1 setTitle:NSLocalizedString(@"全部类型", nil) forState:UIControlStateNormal];
    } else if (recordType == RecordTypeCloseing) {
        //平仓记录
        self.tableView.rowHeight = 307;
        self.btnType0.hidden = NO;
        self.btnType1.hidden = NO;
        self.btnType2.hidden = NO;
    } else if (recordType == RecordTypeRecharge) {
        //充币记录
        self.tableView.rowHeight = 180;
        self.btnType0.hidden = NO;
        [self.btnType0 setTitle:NSLocalizedString(@"全部币种", nil) forState:UIControlStateNormal];
    } else if (recordType == RecordTypeWithdraw) {
        //提币记录
        self.tableView.rowHeight = 205;
        self.btnType0.hidden = NO;
        [self.btnType0 setTitle:NSLocalizedString(@"全部币种", nil) forState:UIControlStateNormal];
    } else {
        self.tableView.rowHeight = 75;
        self.btnType0.hidden = NO;
        if (recordType == RecordTypeCoinAssets || recordType == RecordTypeWalletAssets) {
            //币币资产记录、钱包资产记录
            self.btnType1.hidden = NO;
            [self.btnType0 setTitle:NSLocalizedString(@"全部币种", nil) forState:UIControlStateNormal];
        } else if (recordType == RecordTypeContractAssets) {
            //合约资产记录
            [self.btnType0 setTitle:NSLocalizedString(@"全部币种", nil) forState:UIControlStateNormal];
        } else {
            [self.btnType0 setTitle:NSLocalizedString(@"全部类型", nil) forState:UIControlStateNormal];
        }
    }
}

- (void)updateTypeView {
    RecordType recordType = [(ContractMainViewModel *)self.mainViewModel recordType];
    if (recordType == RecordTypeCoinAssets || recordType == RecordTypeWalletAssets) {
        //币币资产记录、钱包资产记录
        self.dropDownView.arrayTableDatas = [(ContractMainViewModel *)self.mainViewModel arraySymbolDatas];
        self.dropDownView1.arrayTableDatas = [(ContractMainViewModel *)self.mainViewModel arrayRecordTypeDatas];
    } else if (recordType == RecordTypeContractAssets ||
               recordType == RecordTypeWithdraw ||
               recordType == RecordTypeRecharge) {
        //合约资产记录、提币记录、充币记录
        self.dropDownView.arrayTableDatas = [(ContractMainViewModel *)self.mainViewModel arraySymbolDatas];
    } else if (recordType == RecordTypeCloseing) {
        //平仓记录
        self.dropDownView.arrayTableDatas = [(ContractMainViewModel *)self.mainViewModel arraySymbolDatas];
        self.dropDownView1.arrayTableDatas = self.arrayType0;
        self.dropDownView2.arrayTableDatas = self.arrayType1;
    } else if (recordType == RecordTypeDeal) {
        //成交记录
        self.dropDownView.arrayTableDatas = [(ContractMainViewModel *)self.mainViewModel arraySymbolDatas];
        self.dropDownView1.arrayTableDatas = self.arrayType2;
    }
}

#pragma mark - Setter & Getter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        self.btnType0 = [UIButton buttonWithTitle:NSLocalizedString(@"全部合约", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithSelectContractEvent:)];
        [self.btnType0 setImage:[UIImage imageNamed:@"bibi-xl"] forState:UIControlStateNormal];
        self.btnType0.layer.cornerRadius = 2;
        self.btnType0.layer.borderColor = kRGB(236, 236, 236).CGColor;
        self.btnType0.layer.borderWidth = 0.5;
        self.btnType0.hidden = YES;
        [_headerView addSubview:self.btnType0];
        [self.btnType0 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
            make.height.equalTo(28);
            make.width.equalTo(90);
        }];
        [self.btnType0 setTitleLeftSpace:2];
        
        self.btnType1 = [UIButton buttonWithTitle:NSLocalizedString(@"全部类型", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithSelectType1Event:)];
        [self.btnType1 setImage:[UIImage imageNamed:@"bibi-xl"] forState:UIControlStateNormal];
        self.btnType1.layer.cornerRadius = 2;
        self.btnType1.layer.borderColor = kRGB(236, 236, 236).CGColor;
        self.btnType1.layer.borderWidth = 0.5;
        self.btnType1.hidden = YES;
        [_headerView addSubview:self.btnType1];
        [self.btnType1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnType0.mas_right).offset(5);
            make.centerY.equalTo(0);
            make.height.equalTo(28);
            make.width.equalTo(90);
        }];
        [self.btnType1 setTitleLeftSpace:2];
        
        self.btnType2 = [UIButton buttonWithTitle:NSLocalizedString(@"全部类型", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithSelectType2Event:)];
        [self.btnType2 setImage:[UIImage imageNamed:@"bibi-xl"] forState:UIControlStateNormal];
        self.btnType2.layer.cornerRadius = 2;
        self.btnType2.layer.borderColor = kRGB(236, 236, 236).CGColor;
        self.btnType2.layer.borderWidth = 0.5;
        self.btnType2.hidden = YES;
        [_headerView addSubview:self.btnType2];
        [self.btnType2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnType1.mas_right).offset(5);
            make.centerY.equalTo(0);
            make.height.equalTo(28);
            make.width.equalTo(90);
        }];
        [self.btnType2 setTitleLeftSpace:2];
        
        UIButton *btnFilter = [UIButton buttonWithTitle:NSLocalizedString(@"筛选", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(12) target:self selector:@selector(onBtnWithFilterEvent:)];
        btnFilter.layer.cornerRadius = 2;
        btnFilter.backgroundColor = kRGB(0, 102, 237);
        [_headerView addSubview:btnFilter];
        [btnFilter makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.width.equalTo(60);
            make.height.equalTo(34);
            make.centerY.equalTo(0);
        }];
    }
    return _headerView;
}

- (DropDownView *)dropDownView {
    if (!_dropDownView) {
        _dropDownView = [[DropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_dropDownView setOnDidSelectIndexBlock:^(id  _Nonnull obj) {
            if (obj && [obj isKindOfClass:[SymbolModel class]]) {
                SymbolModel *symbolModel = obj;
                [weakSelf.btnType0 setTitle:symbolModel.symbols forState:UIControlStateNormal];
                [(ContractMainViewModel *)weakSelf.mainViewModel setSymbols:symbolModel.symbols];
            } else if (obj && [obj isKindOfClass:[RecordSubModel class]]) {
                RecordSubModel *subModel = obj;
                [weakSelf.btnType0 setTitle:subModel.sources forState:UIControlStateNormal];
                [(ContractMainViewModel *)weakSelf.mainViewModel setFlowType:subModel.code];
            }
            [weakSelf.btnType0 setTitleLeftSpace:2];
            weakSelf.btnType0.layer.borderColor = kRGB(236, 236, 236).CGColor;
        }];
    }
    return _dropDownView;
}

- (DropDownView *)dropDownView1 {
    if (!_dropDownView1) {
        _dropDownView1 = [[DropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_dropDownView1 setOnDidSelectIndexBlock:^(id  _Nonnull obj) {
            if (obj && [obj isKindOfClass:[RecordSubModel class]]) {
                RecordSubModel *subModel = obj;
                [weakSelf.btnType1 setTitle:subModel.sources forState:UIControlStateNormal];
                [(ContractMainViewModel *)weakSelf.mainViewModel setFlowType:subModel.code];
            } else if (obj && [obj isKindOfClass:[NSString class]]) {
                [weakSelf.btnType1 setTitle:obj forState:UIControlStateNormal];
                [(ContractMainViewModel *)weakSelf.mainViewModel setCompactType:obj];
            }
            weakSelf.btnType1.layer.borderColor = kRGB(236, 236, 236).CGColor;
            [weakSelf.btnType1 setTitleLeftSpace:2];
        }];
    }
    return _dropDownView1;
}

- (DropDownView *)dropDownView2 {
    if (!_dropDownView2) {
        _dropDownView2 = [[DropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_dropDownView2 setOnDidSelectIndexBlock:^(id  _Nonnull obj) {
            if (obj && [obj isKindOfClass:[NSString class]]) {
                [weakSelf.btnType2 setTitle:obj forState:UIControlStateNormal];
                [weakSelf.btnType2 setTitleLeftSpace:2];
                [(ContractMainViewModel *)weakSelf.mainViewModel setCloseingStatus:obj];
            }
        }];
    }
    return _dropDownView2;
}

- (NSArray<NSString *> *)arrayType0 {
    if (!_arrayType0) {
        _arrayType0 = @[@"全部类型", @"多仓", @"空仓"];
    }
    return _arrayType0;
}

- (NSArray<NSString *> *)arrayType1 {
    if (!_arrayType1) {
        _arrayType1 = @[@"全部类型", @"强制平仓", @"止盈平仓", @"止损平仓", @"手动平仓"];
    }
    return _arrayType1;
}

- (NSArray<NSString *> *)arrayType2 {
    if (!_arrayType2) {
        _arrayType2 = @[@"全部类型", @"买入", @"卖出", @"撤销"];
    }
    return _arrayType2;
}

@end
