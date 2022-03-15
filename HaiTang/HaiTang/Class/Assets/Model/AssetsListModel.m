//
//  AssetsListModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AssetsListModel.h"

@implementation AssetsListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"list_id" : @"id"};
}

@end
