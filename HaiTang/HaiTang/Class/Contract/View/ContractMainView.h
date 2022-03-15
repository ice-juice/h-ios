//
//  ContractMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"
#import "ContractTableHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ContractMainViewDelegate <BaseTableViewDelegate>
//平仓记录
- (void)tableViewWithCheckCloseRecords:(UITableView *)tableView;
//合约订单列表
- (void)tableViewWithCheckContractOrderList:(UITableView *)tableView;
//下单
- (void)tableViewWithSubmitContract:(UITableView *)tableView;
//平仓
- (void)tableViewWithCloseing:(UITableView *)tableView;
//撤销
- (void)tableViewWithCancelContract:(UITableView *)tableView;
//止损止损
- (void)tableView:(UITableView *)tableView setTakeProfit:(NSString *)profitPrice stopLoss:(NSString *)lossPrice;

@end

@interface ContractMainView : BaseTableView

@property (nonatomic, strong) ContractTableHeaderView *tableHeaderView;

@end

NS_ASSUME_NONNULL_END
