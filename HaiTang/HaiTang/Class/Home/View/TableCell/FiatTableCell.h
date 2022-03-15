//
//  FiatTableCell.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class OrderModel;

@interface FiatTableCell : BaseTableViewCell
//下单
@property (nonatomic, copy) void (^onBtnWithPlaceOnOrderBlock)(OrderModel *orderModel);

@end

NS_ASSUME_NONNULL_END
