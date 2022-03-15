//
//  FiatOrderMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FiatOrderMainViewDelegate <BaseTableViewDelegate>
//查看订单详情
- (void)tableView:(UITableView *)tableView checkOrderDetail:(NSString *)orderNo pageType:(NSString *)pageType;


@end

@interface FiatOrderMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
