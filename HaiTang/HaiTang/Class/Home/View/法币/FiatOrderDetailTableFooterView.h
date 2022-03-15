//
//  FiatOrderDetailTableFooterView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/28.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FiatOrderDetailTableFooterView : BaseView
//取消订单
@property (nonatomic, copy) void (^onBtnWithCancelOrderBlock)(void);
//已完成付款
@property (nonatomic, copy) void (^onBtnWithFinishPayBlock)(void);
//申诉
@property (nonatomic, copy) void (^onBtnWithAppealBlock)(void);
//放币
@property (nonatomic, copy) void (^onBtnWithPutMoneyBlock)(void);

- (void)setViewWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
