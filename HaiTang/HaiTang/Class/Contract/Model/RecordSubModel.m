//
//  RecordSubModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RecordSubModel.h"

@implementation RecordSubModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"type_id" : @"id"};
}

@end
