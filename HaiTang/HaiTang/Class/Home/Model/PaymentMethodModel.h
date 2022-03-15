//
//  PaymentMethodModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NewModel;

@interface PaymentMethodModel : BaseModel
@property (nonatomic, strong) NSArray<NewModel *> *bank;       //银行卡
@property (nonatomic, strong) NSArray<NewModel *> *ali;        //支付宝
@property (nonatomic, strong) NSArray<NewModel *> *payPal;     //payPal
@property (nonatomic, strong) NSArray<NewModel *> *wx;         //微信

@end

NS_ASSUME_NONNULL_END
