//
//  LeverageListModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/26.
//  Copyright © 2020 zy. All rights reserved.
//

#import "LeverageListModel.h"

@implementation LeverageListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"leverage_id" : @"id"};
}

@end
