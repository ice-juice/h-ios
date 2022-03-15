//
//  USDTAssetsMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "USDTAssetsMainView.h"
#import "BaseTableViewCell.h"

#import "BaseTableModel.h"
#import "AssetsMainViewModel.h"

@interface USDTAssetsMainView ()
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIButton *btnTransfer;
@property (nonatomic, strong) UIButton *btnRecord;
@property (nonatomic, strong) UIButton *btnRecharge;
@property (nonatomic, strong) UIButton *btnWithdraw;

@end

@implementation USDTAssetsMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(AssetsMainViewModel *)self.mainViewModel arrayUSDTAssetsTableDatas] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.textLabel.font = kFont(14);
    cell.textLabel.textColor = kRGB(16, 16, 16);
    cell.detailTextLabel.font = kFont(14);
    cell.detailTextLabel.textColor = kRGB(16, 16, 16);
    if (indexPath.row < [[(AssetsMainViewModel *)self.mainViewModel arrayUSDTAssetsTableDatas] count]) {
        BaseTableModel *tableModel = [(AssetsMainViewModel *)self.mainViewModel arrayUSDTAssetsTableDatas][indexPath.row];
        cell.textLabel.text = NSLocalizedString(tableModel.title, nil);
        cell.detailTextLabel.text = tableModel.subTitle;
    }
    return cell;
}

#pragma mark - Event Response
- (void)onBtnWithRechargeEvent:(UIButton *)btn {
    //充币
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithCheckRecharge:)]) {
        [self.delegate performSelector:@selector(tableViewWithCheckRecharge:) withObject:self.tableView];
    }
}

- (void)onBtnWithWithdrawEvent:(UIButton *)btn {
    //提币
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithCheckWithdraw:)]) {
        [self.delegate performSelector:@selector(tableViewWithCheckWithdraw:) withObject:self.tableView];
    }
}

- (void)onBtnWithTransferEvent:(UIButton *)btn {
    //资产划转
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithCheckTransfer:)]) {
        [self.delegate performSelector:@selector(tableViewWithCheckTransfer:) withObject:self.tableView];
    }
}

- (void)onBtnWithRecordEvent:(UIButton *)btn {
    //资产记录
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithCheckRecord:)]) {
        [self.delegate performSelector:@selector(tableViewWithCheckRecord:) withObject:self.tableView];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.tableView = [self setupTableViewWithDelegate:self];
    self.tableView.tableFooterView = self.tableFooterView;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
}

- (void)updateView {
    self.tableView.hidden = NO;
    USDTAssetsType assetsType = [(AssetsMainViewModel *)self.mainViewModel usdtAssetsType];
    if (assetsType == USDTAssetsTypeWallet) {
        //USDT钱包资产
        self.btnRecharge.hidden = NO;
        self.btnWithdraw.hidden = NO;
        [self.btnTransfer updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(80);
        }];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Setter & Getter
- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
        
        self.btnRecharge = [UIButton buttonWithTitle:NSLocalizedString(@"充币", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithRechargeEvent:)];
        self.btnRecharge.layer.cornerRadius = 2;
        self.btnRecharge.backgroundColor = kRGB(0, 102, 237);
        self.btnRecharge.hidden = YES;
        [_tableFooterView addSubview:self.btnRecharge];
        [self.btnRecharge makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(30);
            make.left.equalTo(15);
            make.width.equalTo(160);
            make.height.equalTo(34);
        }];
        
        self.btnWithdraw = [UIButton buttonWithTitle:NSLocalizedString(@"提币", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithWithdrawEvent:)];
        self.btnWithdraw.layer.cornerRadius = 2;
        self.btnWithdraw.hidden = YES;
        self.btnWithdraw.backgroundColor = kRGB(0, 102, 237);
        [_tableFooterView addSubview:self.btnWithdraw];
        [self.btnWithdraw makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(30);
            make.right.equalTo(-15);
            make.width.equalTo(160);
            make.height.equalTo(34);
        }];
        
        self.btnTransfer = [UIButton buttonWithTitle:NSLocalizedString(@"资产划转", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithTransferEvent:)];
        self.btnTransfer.layer.cornerRadius = 2;
        self.btnTransfer.backgroundColor = kRGB(0, 102, 237);
        [_tableFooterView addSubview:self.btnTransfer];
        [self.btnTransfer makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(30);
            make.left.equalTo(15);
            make.width.equalTo(160);
            make.height.equalTo(34);
        }];
        
        self.btnRecord = [UIButton buttonWithTitle:NSLocalizedString(@"资产记录", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithRecordEvent:)];
        self.btnRecord.layer.cornerRadius = 2;
        self.btnRecord.backgroundColor = kRGB(0, 102, 237);
        [_tableFooterView addSubview:self.btnRecord];
        [self.btnRecord makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.width.equalTo(160);
            make.height.equalTo(34);
            make.centerY.equalTo(self.btnTransfer);
        }];
    }
    return _tableFooterView;
}

@end
