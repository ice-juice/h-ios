//
//  AssetsRecordsTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AssetsRecordsTableCell.h"

#import "RecordSubModel.h"

@interface AssetsRecordsTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@end

@implementation AssetsRecordsTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        self.lbName.text = subModel.flowType;
        self.lbTime.text = subModel.createTime;
        UIColor *textColor = [subModel.symbol isEqualToString:@"-"] ? kRGB(205, 61, 88) : kRGB(3, 173, 143);
        self.lbPrice.text = [NSString stringWithFormat:@"%@%.3f", subModel.symbol, [subModel.flowPrice floatValue]];
        self.lbPrice.textColor = textColor;
    }
}

@end
