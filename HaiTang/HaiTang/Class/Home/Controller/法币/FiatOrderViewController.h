//
//  FiatOrderViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FiatOrderViewController : BaseViewController
//订单状态
@property (nonatomic, assign) FiatOrderStatus orderStatus;
//订单类型（0-购买订单 1-出售订单）
@property (nonatomic, assign) NSInteger orderType;

@end

NS_ASSUME_NONNULL_END
