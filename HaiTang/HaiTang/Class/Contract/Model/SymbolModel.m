//
//  SymbolModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SymbolModel.h"
#import "LeverageListModel.h"

@implementation SymbolModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"leverageList" : NSStringFromClass([LeverageListModel class])};
}

@end
