//
//  HomeQuotesViewCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "HomeQuotesViewCell.h"

#import "QuotesModel.h"

@interface HomeQuotesViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lb24Volume;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbCNY;
@property (weak, nonatomic) IBOutlet UILabel *lbRate;

@end

@implementation HomeQuotesViewCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.lbRate.layer.cornerRadius = 4;
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[QuotesModel class]]) {
        QuotesModel *quotesModel = model;
        
        NSString *type = [quotesModel.type isEqualToString:@"1"] ? NSLocalizedString(@"永续", nil) : @"";
        self.lbSymbol.text = [NSString stringWithFormat:@"%@\n%@", quotesModel.symbol, type];
        self.lbSymbol.attributedText = [self.lbSymbol.text attributedStringWithSubString:type subFont:kBoldFont(10)];
        //24H交易量
        self.lb24Volume.text = [NSString stringWithFormat:@"24H%@%ld", NSLocalizedString(@"量", nil), [quotesModel.amount integerValue]];
        
        UIColor *textColor = [quotesModel.rose containsString:@"-"] ? kRGB(205, 61, 88) : kRGB(3, 173, 143);
        //需要保留的小数点位数
        NSInteger number = [quotesModel.number integerValue];
        NSString *format = [NSString stringWithFormat:@"%%.%ldf", number];
        self.lbPrice.text = [NSString stringWithFormat:format, [quotesModel.close floatValue]];
        self.lbPrice.textColor = textColor;
        self.lbCNY.text = [NSString stringWithFormat:@"$%.2f", [quotesModel.cny floatValue]];
        self.lbRate.text = [NSString stringWithFormat:@"%.2f%%", [quotesModel.rose floatValue]];
        self.lbRate.backgroundColor = textColor;
        
    }
}

@end
