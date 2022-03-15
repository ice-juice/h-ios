//
//  PaymentMethodModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PaymentMethodModel.h"
#import "NewModel.h"

@implementation PaymentMethodModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"bank" : NSStringFromClass([NewModel class]),
             @"ali" : NSStringFromClass([NewModel class]),
             @"payPal" : NSStringFromClass([NewModel class]),
             @"wx" : NSStringFromClass([NewModel class])
    };
}

@end
