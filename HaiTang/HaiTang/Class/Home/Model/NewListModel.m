//
//  NewListModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NewListModel.h"
#import "NewModel.h"

@implementation NewListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"records" : NSStringFromClass([NewModel class])};
}

@end
