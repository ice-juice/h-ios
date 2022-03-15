//
//  PaymentMethodView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentMethodView : BaseView
- (void)showView;
- (void)closeView;
- (void)setViewWithModel:(id)model;

//选择收款账号
@property (nonatomic, copy) void (^didSelectPaymentAccountBlock)(NSString *paymentId);
//选择对应需要的收款方式
@property (nonatomic, copy) NSString *paymentMethod;

@end

NS_ASSUME_NONNULL_END
