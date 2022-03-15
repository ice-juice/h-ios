//
//  ContractViewCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ContractViewCell.h"

#import "RecordSubModel.h"

@interface ContractViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbLot;
@property (weak, nonatomic) IBOutlet UILabel *lbValue;
@property (weak, nonatomic) IBOutlet UILabel *lbMargin;
@property (weak, nonatomic) IBOutlet UILabel *lbFee;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UIButton *btnRevoke;

@property (nonatomic, copy) NSString *compactId;

@end

@implementation ContractViewCell
#pragma mark - Event Response
- (IBAction)onBtnWithRevokeEvent:(UIButton *)sender {
    //撤销委托
    if (self.onBtnCancelContractBlock) {
        self.onBtnCancelContractBlock(self.compactId);
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.btnRevoke.layer.cornerRadius = 2;
    self.btnRevoke.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnRevoke.layer.borderWidth = 1;
    self.btnRevoke.custom_acceptEventInterval = 3;
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        self.compactId = subModel.compactId;
        self.lbStatus.text = [subModel.compactType isEqualToString:@"BUY"] ? @"■ 多仓" : @"■ 空仓";
        self.lbStatus.textColor = [subModel.compactType isEqualToString:@"BUY"] ? kRGB(68, 188, 167) : kRGB(205, 61, 88);
        self.lbSymbol.text = [NSString stringWithFormat:@"%@ %@", subModel.leverName, subModel.symbols];
        //委托价格
        self.lbPrice.text = [NSString stringWithFormat:@"%@ %.4f", NSLocalizedString(@"委托价格", nil), [subModel.tradePrice floatValue]];
        //委托手数
        self.lbLot.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"委托手数", nil), subModel.numbers];
        //持仓价值
        NSString *symbol = [subModel.symbols substringToIndex:subModel.symbols.length - 5];
        self.lbValue.text = [NSString stringWithFormat:@"%@ %@%@", NSLocalizedString(@"持仓价值", nil), subModel.openHandPrice, symbol];
        //仓位保证金
        self.lbMargin.text = [NSString stringWithFormat:@"%@(USDT) %.2f", NSLocalizedString(@"仓位保证金", nil), [subModel.positionPrice floatValue]];
        //建仓手续费
        self.lbFee.text = [NSString stringWithFormat:@"%@(USDT) %.2f", NSLocalizedString(@"建仓手续费", nil), [subModel.fee floatValue]];
        //委托时间
        self.lbTime.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"委托时间", nil), subModel.createTime];
    }
}

@end
