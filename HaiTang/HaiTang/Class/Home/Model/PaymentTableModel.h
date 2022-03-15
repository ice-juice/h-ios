//
//  PaymentTableModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2021/2/5.
//  Copyright © 2021 zy. All rights reserved.
//

#import "BaseTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentTableModel : BaseTableModel

@property (nonatomic, assign) AddPaymentType addType;

- (instancetype)initWithImageName:(NSString *)imageName
                            title:(NSString *)title
                   addPaymentType:(AddPaymentType)addType;

@end

NS_ASSUME_NONNULL_END
