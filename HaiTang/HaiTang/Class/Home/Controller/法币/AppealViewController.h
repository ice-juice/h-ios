//
//  AppealViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/28.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppealViewController : BaseViewController
//订单号
@property (nonatomic, copy) NSString *orderNo;
//订单类型
@property (nonatomic, copy) NSString *orderType;

@end

NS_ASSUME_NONNULL_END
