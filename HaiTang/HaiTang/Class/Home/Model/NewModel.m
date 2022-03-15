//
//  NewModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/20.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NewModel.h"

@implementation NewModel
- (void)setType:(NSString *)type {
    if (type) {
        _type = type;
        if ([type isEqualToString:@"WE_CHAT"]) {
            self.imgName = @"wx";
        } else if ([type isEqualToString:@"ALI_PAY"]) {
            self.imgName = @"zfb";
        } else if ([type isEqualToString:@"BANK"]) {
            self.imgName = @"yhk";
        } else {
            self.imgName = @"paypal";
        }
    }
}

@end
