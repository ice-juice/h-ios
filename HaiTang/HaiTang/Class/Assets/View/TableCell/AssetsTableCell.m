//
//  AssetsTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AssetsTableCell.h"

#import "AssetsListModel.h"

@interface AssetsTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbAvailable;

@end

@implementation AssetsTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model == nil) {
        self.lbSymbol.font = kFont(12);
        self.lbTotal.font = kFont(12);
        self.lbAvailable.font = kFont(12);
        self.lbSymbol.text = NSLocalizedString(@"币种", nil);
        self.lbTotal.text = NSLocalizedString(@"总额", nil);
        self.lbAvailable.text = NSLocalizedString(@"可用", nil);
    } else if (model && [model isKindOfClass:[AssetsListModel class]]) {
        AssetsListModel *listModel = model;
        self.lbSymbol.text = listModel.type;
        self.lbTotal.text = [NSString stringWithFormat:@"%.8f", [listModel.totalPrice doubleValue]];
        self.lbAvailable.text = [NSString stringWithFormat:@"%.8f", [listModel.usedPrice doubleValue]];
        self.lbSymbol.textColor = kRGB(16, 16, 16);
        self.lbTotal.textColor = kRGB(16, 16, 16);
        self.lbAvailable.textColor = kRGB(16, 16, 16);
    }
}

@end
