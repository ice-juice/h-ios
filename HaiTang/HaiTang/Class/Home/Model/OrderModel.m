//
//  OrderModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/27.
//  Copyright © 2020 zy. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
- (void)setPayMethod:(NSString *)payMethod {
    if (payMethod) {
        _payMethod = payMethod;
        if ([payMethod isEqualToString:@"ALI_PAY"]) {
            self.payMethodImgName = @"zfb";
            self.payMethodString = @"支付宝";
        } else if ([payMethod isEqualToString:@"WE_CHAT"]) {
            self.payMethodImgName = @"wx";
            self.payMethodString = @"微信";
        } else if ([payMethod isEqualToString:@"BANK"]) {
            self.payMethodImgName = @"yhk";
            self.payMethodString = @"银行卡";
        } else {
            self.payMethodImgName = @"paypal";
            self.payMethodString = @"PayPal";
        }
    }
}

@end
