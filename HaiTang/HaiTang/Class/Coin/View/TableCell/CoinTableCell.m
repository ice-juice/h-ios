//
//  CoinTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CoinTableCell.h"

#import "RecordSubModel.h"

@interface CoinTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbVolumeTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbVolume;
@property (weak, nonatomic) IBOutlet UILabel *lbAveragePrice;
@property (weak, nonatomic) IBOutlet UILabel *lbDealTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbFee;
@property (weak, nonatomic) IBOutlet UILabel *lbOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (nonatomic, copy) NSString *matchId;

@end

@implementation CoinTableCell
#pragma mark - Event Response
- (IBAction)OnBtnWithRevocationCommissionEvent:(UIButton *)sender {
    //撤销委托
    if (self.onBtnWithRevocationCommissionBlock) {
        self.onBtnWithRevocationCommissionBlock(self.matchId);
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.btnCancel.custom_acceptEventInterval = 3;
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        self.matchId = subModel.matchId;
        NSString *symbol = [subModel.symbols substringToIndex:subModel.symbols.length - 5];
        
        NSString *matchType = [subModel.matchType isEqualToString:@"BUY"] ? NSLocalizedString(@"买入", nil) : NSLocalizedString(@"卖出", nil);
        UIColor *textColor = [subModel.matchType isEqualToString:@"BUY"] ? kRGB(68, 188, 167) : kRGB(205, 61, 88);
        self.lbStatus.text = [NSString stringWithFormat:@"■ %@%@", matchType, symbol];
        self.lbStatus.textColor = textColor;
        
        self.lbPrice.text = [NSString stringWithFormat:@"%@\n%.2f", NSLocalizedString(@"委托价格(USDT)", nil), [subModel.unit floatValue]];
        [self.lbPrice setParagraphSpacing:0 lineSpacing:10];
        self.lbPrice.textAlignment = NSTextAlignmentCenter;
        self.lbPrice.attributedText = [self.lbPrice.text attributedStringWithSubString:[NSString stringWithFormat:@"%.2f", [subModel.unit floatValue]] subFont:kBoldFont(12)];
        
        self.lbNumber.text = [NSString stringWithFormat:@"%@(%@)\n%.4f", NSLocalizedString(@"委托数量", nil), symbol, [subModel.willNumberB floatValue]];
        [self.lbNumber setParagraphSpacing:0 lineSpacing:10];
        self.lbNumber.textAlignment = NSTextAlignmentCenter;
        self.lbNumber.attributedText = [self.lbNumber.text attributedStringWithSubString:[NSString stringWithFormat:@"%.4f", [subModel.willNumberB floatValue]] subFont:kBoldFont(12)];
        
        //交易总额 = 委托数量 * 委托价格
        CGFloat totalVolume = [subModel.willNumberB floatValue] * [subModel.unit floatValue];
        
        self.lbVolumeTotal.text = [NSString stringWithFormat:@"%@\n%.2f", NSLocalizedString(@"交易总额(USDT)", nil), totalVolume];
        [self.lbVolumeTotal setParagraphSpacing:0 lineSpacing:10];
        self.lbVolumeTotal.textAlignment = NSTextAlignmentCenter;
        self.lbVolumeTotal.attributedText = [self.lbVolumeTotal.text attributedStringWithSubString:[NSString stringWithFormat:@"%.2f", totalVolume] subFont:kBoldFont(12)];
        
        self.lbVolume.text = [NSString stringWithFormat:@"%@(%@)\n%.4f", NSLocalizedString(@"已成交量", nil), symbol, [subModel.numbersB floatValue]];
        [self.lbVolume setParagraphSpacing:0 lineSpacing:10];
        self.lbVolume.textAlignment = NSTextAlignmentCenter;
        self.lbVolume.attributedText = [self.lbVolume.text attributedStringWithSubString:[NSString stringWithFormat:@"%.4f", [subModel.numbersB floatValue]] subFont:kBoldFont(12)];
        
        self.lbAveragePrice.text = [NSString stringWithFormat:@"%@\n%.2f", NSLocalizedString(@"成交均价(USDT)", nil), [subModel.avgUnit floatValue]];
        [self.lbAveragePrice setParagraphSpacing:0 lineSpacing:10];
        self.lbAveragePrice.textAlignment = NSTextAlignmentCenter;
        self.lbAveragePrice.attributedText = [self.lbAveragePrice.text attributedStringWithSubString:[NSString stringWithFormat:@"%.2f", [subModel.avgUnit floatValue]] subFont:kBoldFont(12)];
        
        self.lbDealTotal.text = [NSString stringWithFormat:@"%@\n%.2f", NSLocalizedString(@"成交总额(USDT)", nil), [subModel.numbersU floatValue]];
        [self.lbDealTotal setParagraphSpacing:0 lineSpacing:10];
        self.lbDealTotal.textAlignment = NSTextAlignmentCenter;
        self.lbDealTotal.attributedText = [self.lbDealTotal.text attributedStringWithSubString:[NSString stringWithFormat:@"%.2f", [subModel.numbersU floatValue]] subFont:kBoldFont(12)];
        
        self.lbFee.text = [NSString stringWithFormat:@"%@ %.4f%@", NSLocalizedString(@"手续费", nil), [subModel.numberFee floatValue], symbol];
        
        self.lbOrderNo.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"订单号", nil), subModel.orderNo];
        
        if ([subModel.type isEqualToString:@"1"]) {
            self.btnCancel.hidden = NO;
            self.lbTime.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"委托时间", nil), subModel.createTime];
        } else {
            self.btnCancel.hidden = YES;
            self.lbTime.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"完成时间", nil), subModel.createTime];
        }
    }
}

@end
