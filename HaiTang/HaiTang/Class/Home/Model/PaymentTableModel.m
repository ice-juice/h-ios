//
//  PaymentTableModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2021/2/5.
//  Copyright © 2021 zy. All rights reserved.
//

#import "PaymentTableModel.h"

@implementation PaymentTableModel

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title addPaymentType:(AddPaymentType)addType {
    self = [super initWithImageName:imageName title:title];
    if (self) {
        _addType = addType;
    }
    return self;
}

@end
