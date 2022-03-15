//
//  CollectionSettingsMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionSettingsMainViewDelegate <BaseTableViewDelegate>
//添加收款方式
- (void)tableViewWithAddPayment:(UITableView *)tableView;
//删除收款方式
- (void)tableView:(UITableView *)tableView deletePayment:(NSString *)paymentId;

@end

@interface CollectionSettingsMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
