//
//  FiatOrderDetailMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FiatOrderDetailMainViewDelegate <BaseTableViewDelegate>
/** 支付时间到，强制取消订单 */
- (void)tableViewCancelOrder:(UITableView *)tableView;
/** 已完成付款 */
- (void)tableViewFinishPay:(UITableView *)tableView;
/** 申诉 */
- (void)tableViewAppeal:(UITableView *)tableView;
/** 放币 */
- (void)tableView:(UITableView *)tableView putMoneyWithPassword:(NSString *)password;
/** 忘记密码 */
- (void)tableViewWithForgetPassword:(UITableView *)tableView;

@end

@interface FiatOrderDetailMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
