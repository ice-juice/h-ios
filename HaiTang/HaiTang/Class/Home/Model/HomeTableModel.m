//
//  HomeTableModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "HomeTableModel.h"

@implementation HomeTableModel

- (instancetype)initWithHomeTableCellType:(HomeTableCellType)cellType {
    self = [super init];
    if (self) {
        _cellHeight = 0;
        _cellType = cellType;
    }
    return self;
}

@end
