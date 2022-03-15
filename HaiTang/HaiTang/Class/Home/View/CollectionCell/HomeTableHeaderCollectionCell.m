//
//  HomeTableHeaderCollectionCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "HomeTableHeaderCollectionCell.h"

#import "QuotesModel.h"

@interface HomeTableHeaderCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbRate;
@property (weak, nonatomic) IBOutlet UILabel *lbCNY;

@end

@implementation HomeTableHeaderCollectionCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[QuotesModel class]]) {
        QuotesModel *quotesModel = model;
        self.lbSymbol.text = [NSString stringWithFormat:@"%@\n(%@)", quotesModel.symbol, NSLocalizedString(@"永续", nil)];
        
        UIColor *roseTextColor = [quotesModel.rose containsString:@"-"] ? kRGB(205, 61, 88) : kRGB(3, 173, 143);
        
        //需要保留的小数点位数
        NSInteger number = [quotesModel.number integerValue];
        NSString *format = [NSString stringWithFormat:@"%%.%ldf", number];
        self.lbPrice.text = [NSString stringWithFormat:format, [quotesModel.close floatValue]];
        self.lbPrice.textColor = roseTextColor;
        
        self.lbRate.text = [NSString stringWithFormat:@"%.2f%%", [quotesModel.rose floatValue]];
        self.lbRate.textColor = roseTextColor;
        
        self.lbCNY.text = [NSString stringWithFormat:@"≈$%.2f", [quotesModel.cny floatValue]];
    }
}


@end
