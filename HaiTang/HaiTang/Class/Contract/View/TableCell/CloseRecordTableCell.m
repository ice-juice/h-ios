//
//  CloseRecordTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CloseRecordTableCell.h"

#import "RecordSubModel.h"

@interface CloseRecordTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbCloseStatus;
@property (weak, nonatomic) IBOutlet UIView *closeStatusView;
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lbProfitAndLoss;     //平仓盈亏
@property (weak, nonatomic) IBOutlet UILabel *lbLot;
@property (weak, nonatomic) IBOutlet UILabel *lbCloseLot;
@property (weak, nonatomic) IBOutlet UILabel *lbCloseValue;
@property (weak, nonatomic) IBOutlet UILabel *lbProfitPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbLossPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbOpeningPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbClosePrice;
@property (weak, nonatomic) IBOutlet UILabel *lbMargin;
@property (weak, nonatomic) IBOutlet UILabel *lbCloseMargin;
@property (weak, nonatomic) IBOutlet UILabel *lbFee;
@property (weak, nonatomic) IBOutlet UILabel *lbOrder;
@property (weak, nonatomic) IBOutlet UILabel *lbOpeningTime;
@property (weak, nonatomic) IBOutlet UILabel *lbCloseTime;

@end

@implementation CloseRecordTableCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.closeStatusView.layer.cornerRadius = 4;
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        
        self.lbStatus.text = [subModel.compactType isEqualToString:@"BUY"] ? @"■ 多仓" : @"■ 空仓";
        self.lbStatus.textColor = [subModel.compactType isEqualToString:@"BUY"] ? kRGB(68, 188, 167) : kRGB(205, 61, 88);
        
        self.lbSymbol.text = [NSString stringWithFormat:@"%@ %@", subModel.leverName, subModel.symbols];
        
        NSString *symbol = [subModel.symbols substringToIndex:subModel.symbols.length - 5];
        
        self.lbProfitAndLoss.text = [NSString stringWithFormat:@"%.2f(%.2f%%)", [subModel.lossProfit floatValue], [subModel.lossProfitRatio floatValue]];
        self.lbProfitAndLoss.textColor = self.lbStatus.textColor;
    
        self.lbCloseStatus.text = subModel.exitType;
        
        self.lbLot.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"持仓手数", nil), subModel.numbers];
        
        self.lbCloseLot.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"平仓手数", nil), subModel.closeNumber];
        
        self.lbCloseValue.text = [NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"平仓价值", nil), [subModel.handPrice integerValue]];
        
        self.lbProfitPrice.text = [NSString stringWithFormat:@"%@ %.2f", NSLocalizedString(@"止盈价格", nil), [subModel.stopProfit floatValue]];
        self.lbProfitPrice.attributedText = [self.lbProfitPrice.text attributedStringWithSubString:[NSString stringWithFormat:@"%.2f", [subModel.stopProfit floatValue]] subColor:kRGB(68, 188, 167)];
        
        self.lbLossPrice.text = [NSString stringWithFormat:@"%@ %.2f", NSLocalizedString(@"止损价格", nil), [subModel.stopLoss floatValue]];
        self.lbLossPrice.attributedText = [self.lbLossPrice.text attributedStringWithSubString:[NSString stringWithFormat:@"%.2f", [subModel.stopLoss floatValue]] subColor:kRGB(205, 61, 88)];
        
        self.lbOpeningPrice.text = [NSString stringWithFormat:@"%@ %.4f", NSLocalizedString(@"建仓价格", nil), [subModel.tradePrice floatValue]];
        
        self.lbClosePrice.text = [NSString stringWithFormat:@"%@ %.4f", NSLocalizedString(@"平仓价格", nil), [subModel.exitPrice floatValue]];
        
        self.lbMargin.text = [NSString stringWithFormat:@"%@ %.4f", NSLocalizedString(@"持仓保证金", nil), [subModel.positionPrice floatValue]];
        
        self.lbCloseMargin.text = [NSString stringWithFormat:@"%@ %.4f", NSLocalizedString(@"平仓保证金", nil), [subModel.exitPositionPrice floatValue]];
        
        self.lbFee.text = [NSString stringWithFormat:@"%@ %.4f", NSLocalizedString(@"平仓手续费(USDT)", nil), [subModel.closeFeePrice floatValue]];
        
        self.lbOrder.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"订单号", nil), subModel.orderNo];
        
        self.lbOpeningTime.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"建仓时间", nil), subModel.createTime];
        
        self.lbCloseTime.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"平仓时间", nil), subModel.exitTime];
    }
}

@end
