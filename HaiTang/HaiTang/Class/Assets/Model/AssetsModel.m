//
//  AssetsModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AssetsModel.h"
#import "AssetsListModel.h"

@implementation AssetsModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : NSStringFromClass([AssetsListModel class])};
}

@end
