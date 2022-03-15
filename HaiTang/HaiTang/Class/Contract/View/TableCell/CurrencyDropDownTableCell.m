//
//  CurrencyDropDownTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/27.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CurrencyDropDownTableCell.h"

#import "QuotesModel.h"

@interface CurrencyDropDownTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbRose;

@end

@implementation CurrencyDropDownTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[QuotesModel class]]) {
        QuotesModel *quotesModel = model;
        NSString *type = [quotesModel.type isEqualToString:@"1"] ? NSLocalizedString(@"永续", nil) : @"";
        self.lbSymbol.text = [NSString stringWithFormat:@"%@%@", quotesModel.symbol, type];
        
        //需要保留的小数点位数
        NSInteger number = [quotesModel.number integerValue];
        NSString *format = [NSString stringWithFormat:@"%%.%ldf", number];
        self.lbPrice.text = [NSString stringWithFormat:format, [quotesModel.close floatValue]];
        
        NSString *fuHao = [quotesModel.rose containsString:@"-"] ? @"" : @"+";
        UIColor *roseTextColor = [quotesModel.rose containsString:@"-"] ? kRGB(205, 61, 88) : kRGB(3, 173, 143);
        self.lbRose.text = [NSString stringWithFormat:@"%@%.2f%%", fuHao, [quotesModel.rose floatValue]];
        self.lbRose.textColor = roseTextColor;
        self.lbPrice.textColor = roseTextColor;
    }
}

@end
