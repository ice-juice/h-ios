//
//  RecordModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RecordModel.h"
#import "RecordSubModel.h"

@implementation RecordModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"records" : NSStringFromClass([RecordSubModel class])};
}

@end
