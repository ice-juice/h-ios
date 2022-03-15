//
//  ContractTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ContractTableCell.h"

#import "RecordSubModel.h"

@interface ContractTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lbProfitAndLossValue;
@property (weak, nonatomic) IBOutlet UILabel *openingPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbLot;
@property (weak, nonatomic) IBOutlet UILabel *lbValue;
@property (weak, nonatomic) IBOutlet UILabel *takeProfitPrice;
@property (weak, nonatomic) IBOutlet UILabel *stopLossPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbMargin;
@property (weak, nonatomic) IBOutlet UILabel *lbFee;
@property (weak, nonatomic) IBOutlet UILabel *lbOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UIButton *btnProfitAndLoss;
@property (weak, nonatomic) IBOutlet UIButton *btnPingCang;
@property (weak, nonatomic) IBOutlet UIButton *btnForward;

@property (nonatomic, copy) NSString *compactId;

@property (nonatomic, strong) RecordSubModel *subModel;

@end

@implementation ContractTableCell
#pragma mark - Event Response
- (IBAction)onBtnWithProfitAndLossEvent:(UIButton *)sender {
    //止盈止损
    if (self.onBtnSetTakeProfitAndStopLossBlock) {
        self.onBtnSetTakeProfitAndStopLossBlock(self.compactId);
    }
}

- (IBAction)onBtnWithPingCangEvent:(UIButton *)sender {
    //平仓
    if (self.onBtnCloseingBlock) {
        self.onBtnCloseingBlock(self.subModel);
    }
}

- (IBAction)onBtnWithForwardEvent:(UIButton *)sender {
    //分享
    if (self.onBtnShareBlock) {
        self.onBtnShareBlock(self.subModel);
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.btnProfitAndLoss.layer.cornerRadius = 2;
    self.btnProfitAndLoss.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnProfitAndLoss.layer.borderWidth = 1;
    self.btnProfitAndLoss.custom_acceptEventInterval = 3;
    
    self.btnPingCang.layer.cornerRadius = 2;
    self.btnPingCang.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnPingCang.layer.borderWidth = 1;
    self.btnPingCang.custom_acceptEventInterval = 3;

    self.btnForward.layer.cornerRadius = 2;
    self.btnForward.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnForward.layer.borderWidth = 1;
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        self.subModel = model;
        self.compactId = self.subModel.compactId;
        self.lbStatus.text = [self.subModel.compactType isEqualToString:@"BUY"] ? @"■ 多仓" : @"■ 空仓";
        self.lbStatus.textColor = [self.subModel.compactType isEqualToString:@"BUY"] ? kRGB(68, 188, 167) : kRGB(205, 61, 88);
        self.lbSymbol.text = [NSString stringWithFormat:@"%@ %@", self.subModel.leverName, self.subModel.symbols];
        //建仓价格
        self.openingPrice.text = [NSString stringWithFormat:@"%@ %.4f", NSLocalizedString(@"建仓价格", nil), [self.subModel.tradePrice floatValue]];
        //持仓手数
        self.lbLot.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"持仓手数", nil), self.subModel.numbers];
        //持仓价值
//        NSString *symbol = [self.subModel.symbols substringToIndex:self.subModel.symbols.length - 5];
        self.lbValue.text = [NSString stringWithFormat:@"%@ %.1f", NSLocalizedString(@"持仓价值", nil), [self.subModel.openHandPrice floatValue]];
        //止盈价格
        NSString *stopProfitPrice = [NSString isEmpty:self.subModel.stopProfit] ? @"--" : [NSString stringWithFormat:@"%.1f", [self.subModel.stopProfit floatValue]];
        self.takeProfitPrice.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"止盈价格", nil), stopProfitPrice];
        self.takeProfitPrice.attributedText = [self.takeProfitPrice.text attributedStringWithSubString:stopProfitPrice subColor:kRGB(68, 188, 167)];
        //止损价格
        NSString *stopLossPrice = [NSString isEmpty:self.subModel.stopLoss] ? @"--" : [NSString stringWithFormat:@"%.1f", [self.subModel.stopLoss floatValue]];
        self.stopLossPrice.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"止损价格", nil), stopLossPrice];
        self.stopLossPrice.attributedText = [self.stopLossPrice.text attributedStringWithSubString:stopLossPrice subColor:kRGB(205, 61, 88)];
        //仓位保证金
        self.lbMargin.text = [NSString stringWithFormat:@"%@(USDT) %.2f", NSLocalizedString(@"仓位保证金", nil), [self.subModel.positionPrice floatValue]];
        //建仓手续费
        self.lbFee.text = [NSString stringWithFormat:@"%@(USDT) %.2f", NSLocalizedString(@"建仓手续费", nil), [self.subModel.fee floatValue]];
        //订单号
        self.lbOrderNo.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"订单号", nil), self.subModel.orderNo];
        //建仓时间
        self.lbTime.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"建仓时间", nil), self.subModel.createTime];
        
        CGFloat profitAndLoss = 0.00;
        
        if ([self.subModel.compactType isEqualToString:@"BUY"]) {
            //买入做多（多仓）当前盈亏 = 持仓价值数量 *（当前行情价-建仓价格）
            profitAndLoss = [self.subModel.openHandPrice floatValue] * ([self.subModel.currentPrice floatValue] - [self.subModel.tradePrice floatValue]);
        } else {
            //卖出做多（空仓）当前盈亏=持仓价值数量*（建仓价格-当前行情价
            profitAndLoss = [self.subModel.openHandPrice floatValue] * ([self.subModel.tradePrice floatValue] - [self.subModel.currentPrice floatValue]);
        }
        if (isnan(profitAndLoss)) {
            profitAndLoss = 0.00;
        }
        if (isinf(profitAndLoss)) {
            profitAndLoss = 0.00;
        }
        
        //盈亏百分比 = 盈亏额 / （持仓手数 * 每手价值数量 * 建仓价格） * 100%
        CGFloat profitAndLossRatio = (profitAndLoss / ([self.subModel.numbers floatValue] * [self.subModel.handNumber floatValue] * [self.subModel.tradePrice floatValue])) * 100;
        
        //当前盈亏
        self.lbProfitAndLossValue.text = [NSString stringWithFormat:@"%.2f(%.2f%%)", profitAndLoss, profitAndLossRatio];
        self.lbProfitAndLossValue.textColor = profitAndLoss < 0 ? kRedColor : kGreenColor;
    }
}

@end
