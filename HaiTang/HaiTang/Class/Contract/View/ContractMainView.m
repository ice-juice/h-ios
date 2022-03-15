//
//  ContractMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ContractMainView.h"
#import "ContractViewCell.h"
#import "ContractTableCell.h"
#import "BaseTableViewCell.h"
#import "StopLossPopupView.h"
#import "ClosePopupView.h"
#import "SharePopupView.h"
#import "MarginPopupView.h"
#import "ContractTableHeaderView.h"

#import "QuotesModel.h"
#import "RecordSubModel.h"
#import "ContractMainViewModel.h"

@interface ContractMainView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) StopLossPopupView *stopLossView;
@property (nonatomic, strong) ClosePopupView *closeView;
@property (nonatomic, strong) MarginPopupView *cancelContractView;
@property (nonatomic, strong) MarginPopupView *closeAllView;
@property (nonatomic, strong) SharePopupView *shareView;
@property (nonatomic, assign) NSInteger selectedIndex;   //0-当前持仓 1-当前委托（默认持仓）

@end

@implementation ContractMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(ContractMainViewModel *)self.mainViewModel arrayContractOrderDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.selectedIndex == 0 ? 310 : 260;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    if (indexPath.row < [[(ContractMainViewModel *)self.mainViewModel arrayContractOrderDatas] count]) {
        RecordSubModel *subModel = [(ContractMainViewModel *)self.mainViewModel arrayContractOrderDatas][indexPath.section];
        if (self.selectedIndex == 0) {
            //当前持仓
            cell = [ContractTableCell cellWithTableNibView:tableView];
            WeakSelf
            [(ContractTableCell *)cell setOnBtnSetTakeProfitAndStopLossBlock:^(NSString * _Nonnull compactId) {
                //止盈止损
                [(ContractMainViewModel *)weakSelf.mainViewModel setCompactId:compactId];
                [weakSelf.stopLossView showView];
            }];
            [(ContractTableCell *)cell setOnBtnCloseingBlock:^(RecordSubModel * _Nonnull subModel) {
                //平仓
                [weakSelf.closeView setViewWithModel:subModel];
            }];
            [(ContractTableCell *)cell setOnBtnShareBlock:^(RecordSubModel * _Nonnull subModel) {
                //分享
                [weakSelf.shareView setViewWithModel:subModel];
            }];
        } else {
            //当前委托
            cell = [ContractViewCell cellWithTableNibView:tableView];
            WeakSelf
            [(ContractViewCell *)cell setOnBtnCancelContractBlock:^(NSString * _Nonnull compactId) {
                //撤销委托
                [(ContractMainViewModel *)weakSelf.mainViewModel setCompactId:compactId];
                [(ContractMainViewModel *)weakSelf.mainViewModel setOperationType:@"1"];
                [weakSelf.cancelContractView showViewWithPopupType:PopupTypeCancelContract];
            }];
        }
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
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.hidden = NO;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
    self.selectedIndex = 0;
}

- (void)updateView {    
    NSString *currentPrice =  [(ContractMainViewModel *)self.mainViewModel currentQuotesModel].close;
    self.closeView.lbClosePrice.text = currentPrice;
    [self.closeView calculationProfitAndLoss];
    
    self.shareView.lbCurrentPrice.text = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"当前价格", nil), currentPrice];
    [self.shareView.lbCurrentPrice setParagraphSpacing:0 lineSpacing:10];
    self.shareView.lbCurrentPrice.attributedText = [self.shareView.lbCurrentPrice.text attributedStringWithSubString:currentPrice subColor:[UIColor whiteColor] subFont:kFont(18)];
    
    UIColor *btnTitleColor = [[(ContractMainViewModel *)self.mainViewModel arrayContractOrderDatas] count] ? kRGB(0, 102, 237) : kRGB(153, 153, 153);
    [self.tableHeaderView.btnPingCang setTitleColor:btnTitleColor forState:UIControlStateNormal];
    self.tableHeaderView.btnPingCang.enabled = [[(ContractMainViewModel *)self.mainViewModel arrayContractOrderDatas] count] ? YES : NO;
    
    [self.tableView reloadData];
}

#pragma mark - Setter & Getter
- (ContractTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[ContractTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 458)];
        WeakSelf
        [_tableHeaderView setOnBtnWithSelectCurrentBlock:^(NSInteger index) {
            //选择持仓、委托
            weakSelf.selectedIndex = index;
            NSString *type = index == 0 ? @"N" : @"IN";
            [(ContractMainViewModel *)weakSelf.mainViewModel setContract_type:type];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithCheckContractOrderList:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithCheckContractOrderList:) withObject:weakSelf.tableView];
            }
        }];
        [_tableHeaderView setOnBtnWithCheckCloseRecordsBlock:^{
            //平仓记录
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithCheckCloseRecords:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithCheckCloseRecords:) withObject:weakSelf.tableView];
            }
        }];
        [_tableHeaderView setOnBtnWithSelectPriceBlock:^(NSInteger index) {
            //选择市价、限价
            CGFloat tableHeaderHeight = index == 0 ? 458 : 500;
            weakSelf.tableHeaderView.height = tableHeaderHeight;
            NSString *dealWay = index == 0 ? @"MARKET" : @"LIMIT";
            [(ContractMainViewModel *)weakSelf.mainViewModel setDealWay:dealWay];
        }];
        [_tableHeaderView setOnBtnWithSelectAllOrCurrentBlock:^(NSInteger index) {
            //选择全部或当前合约
            NSString *showMethod = index == 0 ? @"ALL" : @"CURRENT";
            [(ContractMainViewModel *)weakSelf.mainViewModel setShowMethod:showMethod];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithCheckContractOrderList:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithCheckContractOrderList:) withObject:weakSelf.tableView];
            }
        }];
        [_tableHeaderView setOnSubmitOrderBlock:^(NSString * _Nonnull unit, NSString * _Nonnull numbers, NSString * _Nonnull compactType, NSString * _Nonnull leverageId) {
            //下单
            [(ContractMainViewModel *)weakSelf.mainViewModel setUnitPrice:unit];
            [(ContractMainViewModel *)weakSelf.mainViewModel setNumbers:numbers];
            [(ContractMainViewModel *)weakSelf.mainViewModel setCompactType:compactType];
            [(ContractMainViewModel *)weakSelf.mainViewModel setLeverageId:leverageId];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithSubmitContract:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithSubmitContract:) withObject:weakSelf.tableView];
            }
        }];
        [_tableHeaderView setOnBtnCloseingOrCancelContractBlock:^{
            [(ContractMainViewModel *)weakSelf.mainViewModel setOperationType:@"2"];
            [(ContractMainViewModel *)weakSelf.mainViewModel setCompactId:@""];
            [(ContractMainViewModel *)weakSelf.mainViewModel setNumbers:@""];
            if (weakSelf.selectedIndex == 0) {
                //一键平仓
                [weakSelf.closeAllView showViewWithPopupType:PopupTypeCloseingAll];
            } else {
                //全部撤销
                [weakSelf.cancelContractView showViewWithPopupType:PopupTypeCancelAllContract];
            }
        }];
    }
    return _tableHeaderView;
}

- (StopLossPopupView *)stopLossView {
    if (!_stopLossView) {
        _stopLossView = [[StopLossPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_stopLossView setOnBtnSetTakeProfitAndStopLossBlock:^(NSString * _Nonnull profitPrice, NSString * _Nonnull lossPrice) {
            //止盈止损
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableView:setTakeProfit:stopLoss:)]) {
                [[NSInvocation invocationWithTarget:weakSelf.delegate selector:@selector(tableView:setTakeProfit:stopLoss:) params:@[weakSelf.tableView, profitPrice, lossPrice]] invoke];
            }
        }];
    }
    return _stopLossView;
}

- (ClosePopupView *)closeView {
    if (!_closeView) {
        _closeView = [[ClosePopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_closeView setOnBtnCloseingBlock:^(NSString * _Nonnull compactId, NSString * _Nonnull number) {
            //平仓
            [(ContractMainViewModel *)weakSelf.mainViewModel setCompactId:compactId];
            [(ContractMainViewModel *)weakSelf.mainViewModel setNumbers:number];
            [(ContractMainViewModel *)weakSelf.mainViewModel setOperationType:@"1"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithCloseing:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithCloseing:) withObject:weakSelf.tableView];
            }
        }];
    }
    return _closeView;
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

- (MarginPopupView *)closeAllView {
    if (!_closeAllView) {
        _closeAllView = [[MarginPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_closeAllView setOnBtnWithYesBlock:^{
            //一键平仓
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithCloseing:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithCloseing:) withObject:weakSelf.tableView];
            }
        }];
    }
    return _closeAllView;
}

- (SharePopupView *)shareView {
    if (!_shareView) {
        _shareView = [[SharePopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _shareView;
}

@end
