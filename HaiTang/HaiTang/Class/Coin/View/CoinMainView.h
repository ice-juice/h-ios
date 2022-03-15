//
//  CoinMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"
#import "CoinTableHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CoinMainViewDelegate <BaseTableViewDelegate>
//成交记录
- (void)tableViewWithCheckDealRecord:(UITableView *)tableView;
//交易类型
- (void)tableViewWithDidSelectMatchType:(UITableView *)tableView;
//提交交易
- (void)tableView:(UITableView *)tableView submitDealWithPrice:(NSString *)price number:(NSString *)number;
//撤销委托
- (void)tableViewWithCancelContract:(UITableView *)tableView;

@end

@interface CoinMainView : BaseTableView

@property (nonatomic, strong) CoinTableHeaderView *tableHeaderView;

@end

NS_ASSUME_NONNULL_END
