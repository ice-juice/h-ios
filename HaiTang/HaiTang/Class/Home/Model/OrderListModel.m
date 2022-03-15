//
//  OrderListModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/27.
//  Copyright © 2020 zy. All rights reserved.
//

#import "OrderListModel.h"
#import "OrderModel.h"

@implementation OrderListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"records" : NSStringFromClass([OrderModel class])};
}

@end
