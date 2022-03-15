//
//  FiatMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FiatMainViewDelegate <BaseTableViewDelegate>
//查看我要购买、我要出售订单
- (void)tableViewWithCheckFiatOrder:(UITableView *)tableView;
//查看我的订单
- (void)tableViewWithCheckMineOrder:(UITableView *)tableView;
//下单购买
- (void)tableViewWithOrderBuy:(UITableView *)tableView;
//忘记密码
- (void)tableViewWithForgetPassword:(UITableView *)tableView;
//下单出售
- (void)tableViewWithOrderSell:(UITableView *)tableView;

@end

@interface FiatMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
