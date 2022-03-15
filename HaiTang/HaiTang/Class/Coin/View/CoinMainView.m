//
//  CoinMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CoinMainView.h"
#import "CoinTableCell.h"
#import "MarginPopupView.h"
#import "CoinTableHeaderView.h"

#import "RecordSubModel.h"
#import "CoinMainViewModel.h"

@interface CoinMainView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MarginPopupView *cancelContractView;

@end

@implementation CoinMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(CoinMainViewModel *)self.mainViewModel arrayCommOrRecordDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CoinTableCell *cell = [CoinTableCell cellWithTableNibView:tableView];
    if (indexPath.section < [[(CoinMainViewModel *)self.mainViewModel arrayCommOrRecordDatas] count]) {
        RecordSubModel *subModel = [(CoinMainViewModel *)self.mainViewModel arrayCommOrRecordDatas][indexPath.section];
        WeakSelf
        [cell setOnBtnWithRevocationCommissionBlock:^(NSString * _Nonnull matchId) {
            //撤销委托
            [(CoinMainViewModel *)weakSelf.mainViewModel setCompactId:matchId];
            [weakSelf.cancelContractView showViewWithPopupType:PopupTypeCancelContract];
        }];
        [cell setViewWithModel:subModel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped shouldRefresh:YES];
    self.tableView.rowHeight = 265;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.hidden = NO;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
}

- (void)updateView {
    [self.tableView reloadData];
}

#pragma mark - Setter & Getter
- (CoinTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[CoinTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 405)];
        WeakSelf
        [_tableHeaderView setOnBtnWithCheckDealRecordBlock:^{
            //成交记录
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithCheckDealRecord:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithCheckDealRecord:) withObject:weakSelf.tableView];
            }
        }];
        [_tableHeaderView setOnDidSelectMatchTypeBlock:^(NSString * _Nonnull matchType) {
            //交易类型
            [(CoinMainViewModel *)weakSelf.mainViewModel setMatchType:matchType];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithDidSelectMatchType:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithDidSelectMatchType:) withObject:matchType];
            }
        }];
        [_tableHeaderView setOnDidSelectDealWayBlock:^(NSString * _Nonnull dealWay) {
            [(CoinMainViewModel *)weakSelf.mainViewModel setDealWay:dealWay];
        }];
        [_tableHeaderView setOnBtnWithSubmitDealBlock:^(NSString * _Nonnull price, NSString * _Nonnull number) {
            //提交交易
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableView:submitDealWithPrice:number:)]) {
                [[NSInvocation invocationWithTarget:weakSelf.delegate selector:@selector(tableView:submitDealWithPrice:number:) params:@[weakSelf.tableView, price, number]] invoke];
            }
        }];
    }
    return _tableHeaderView;
}

- (MarginPopupView *)cancelContractView {
    if (!_cancelContractView) {
        _cancelContractView = [[MarginPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_cancelContractView setOnBtnWithYesBlock:^{
            //撤销委托
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithCancelContract:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithCancelContract:) withObject:weakSelf.tableView];
            }
        }];
    }
    return _cancelContractView;
}

@end
