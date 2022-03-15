//
//  WithdrawRecordsTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "WithdrawRecordsTableCell.h"

#import "RecordSubModel.h"

@interface WithdrawRecordsTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbFee;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbID;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@end

@implementation WithdrawRecordsTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        self.lbStatus.text = [NSString stringWithFormat:@"■ %@", subModel.status];
        
        self.lbSymbol.text = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"币种", nil), subModel.coin];
        [self.lbSymbol setParagraphSpacing:0 lineSpacing:5];
        self.lbSymbol.textAlignment = NSTextAlignmentCenter;
        self.lbSymbol.attributedText = [self.lbSymbol.text attributedStringWithSubString:subModel.coin subColor:kRGB(16, 16, 16) subFont:kBoldFont(14)];
        
        self.lbNumber.text = [NSString stringWithFormat:@"%@\n%.4f", NSLocalizedString(@"数量", nil), [subModel.price floatValue]];
        [self.lbNumber setParagraphSpacing:0 lineSpacing:5];
        self.lbNumber.textAlignment = NSTextAlignmentCenter;
        self.lbNumber.attributedText = [self.lbNumber.text attributedStringWithSubString:[NSString stringWithFormat:@"%.4f", [subModel.price floatValue]] subColor:kRGB(16, 16, 16) subFont:kBoldFont(14)];
        
        self.lbFee.text = [NSString stringWithFormat:@"%@\n%.4f", NSLocalizedString(@"手续费", nil), [subModel.fee floatValue]];
        [self.lbFee setParagraphSpacing:0 lineSpacing:5];
        self.lbFee.textAlignment = NSTextAlignmentCenter;
        self.lbFee.attributedText = [self.lbFee.text attributedStringWithSubString:[NSString stringWithFormat:@"%.4f", [subModel.fee floatValue]] subColor:kRGB(16, 16, 16) subFont:kBoldFont(14)];
        
        self.lbAddress.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"提币地址", nil), subModel.address];
        self.lbID.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"区块链交易ID", nil), subModel.txHash];
        self.lbTime.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"时间", nil), subModel.time];

    }
}

@end
