//
//  TradeListSubModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "TradeListSubModel.h"

@implementation TradeListSubModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"model_id" : @"id"};
}

@end
