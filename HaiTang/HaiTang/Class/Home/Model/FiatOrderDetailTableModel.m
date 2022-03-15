//
//  FiatOrderDetailTableModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderDetailTableModel.h"

@implementation FiatOrderDetailTableModel
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle cellType:(FiatOrderDetailCellType)cellType {
    self = [super initWithTitle:title subTitle:subTitle];
    if (self) {
        _cellType = cellType;
    }
    return self;
}

@end
