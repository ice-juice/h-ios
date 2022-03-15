//
//  PendingOrderDetailViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class OrderModel;

@interface PendingOrderDetailViewController : BaseViewController
@property (nonatomic, strong) OrderModel *orderModel;

@end

NS_ASSUME_NONNULL_END
