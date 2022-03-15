//
//  PaymentMethodMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@class PaymentTableModel;

@protocol PaymentMethodMainViewDelegate <BaseTableViewDelegate>
//添加收款方式
- (void)tableView:(UITableView *)tableView addPayment:(PaymentTableModel *)tableModel;

@end

@interface PaymentMethodMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
