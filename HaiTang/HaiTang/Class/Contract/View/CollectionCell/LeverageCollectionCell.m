//
//  LeverageCollectionCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/26.
//  Copyright © 2020 zy. All rights reserved.
//

#import "LeverageCollectionCell.h"

#import "LeverageListModel.h"

@interface LeverageCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@end

@implementation LeverageCollectionCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[LeverageListModel class]]) {
        LeverageListModel *listModel = model;
        self.lbTitle.text = listModel.name;
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        self.lbTitle.backgroundColor = kRGB(68, 188, 167);
        self.lbTitle.textColor = [UIColor whiteColor];
    } else {
        self.lbTitle.backgroundColor = kRGB(249, 249, 249);
        self.lbTitle.textColor = kRGB(16, 16, 16);
    }
}

@end
