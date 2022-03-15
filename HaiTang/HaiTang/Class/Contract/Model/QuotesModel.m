//
//  QuotesModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/26.
//  Copyright © 2020 zy. All rights reserved.
//

#import "QuotesModel.h"

@implementation QuotesModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"quotes_id" : @"id"};
}

@end
