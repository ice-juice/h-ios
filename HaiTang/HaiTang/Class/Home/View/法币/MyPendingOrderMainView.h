//
//  MyPendingOrderMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@class OrderModel;

@protocol MyPendingOrderMainViewDelegate <BaseTableViewDelegate>
//查看订单详情
- (void)tableView:(UITableView *)tableView checkOrderDetail:(OrderModel *)orderModel;

@end

@interface MyPendingOrderMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
