//
//  OrderListModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/27.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class OrderModel;

@interface OrderListModel : BaseModel
@property (nonatomic, strong) NSArray<OrderModel *> *records;

@end

NS_ASSUME_NONNULL_END
