//  下单
//  OrderPopupView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/28.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderPopupView : BaseView
- (void)showView;
- (void)closeView;
- (void)setViewWithModel:(id)model;

//下单购买
@property (nonatomic, copy) void (^onBtnWithOrderBuyBlock)(NSString *orderId, NSString *value, NSInteger type);
//下单出售
@property (nonatomic, copy) void (^onBtnWithOrderSellBlock)(NSString *buyId, NSString *value, NSInteger type);
@property (nonatomic, copy) NSString *paymentMethod;

@end

NS_ASSUME_NONNULL_END
