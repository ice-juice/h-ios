//
//  FiatOrderDetailViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FiatOrderDetailViewController : BaseViewController
//订单号
@property (nonatomic, copy) NSString *orderNo;
//购买订单-BUY 出售订单-SELL
@property (nonatomic, copy) NSString *pageType;

@end

NS_ASSUME_NONNULL_END
