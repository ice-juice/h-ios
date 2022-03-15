//
//  RechargeRecordsTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RechargeRecordsTableCell.h"

#import "RecordSubModel.h"

@interface RechargeRecordsTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbHash;
@property (weak, nonatomic) IBOutlet UILabel *lbSymbol;

@end

@implementation RechargeRecordsTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        self.lbName.text = [NSString stringWithFormat:@"■ %@", subModel.status];
        self.lbTime.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"时间：", nil), subModel.time];
        self.lbHash.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"区块链交易ID：", nil), subModel.txHash];
        
        self.lbNumber.text = [NSString stringWithFormat:@"%@\n\n%.4f", NSLocalizedString(@"充币数量", nil), [subModel.price floatValue]];
        self.lbNumber.attributedText = [self.lbNumber.text attributedStringWithSubString:[NSString stringWithFormat:@"%.4f", [subModel.price floatValue]] subColor:kRGB(16, 16, 16) subFont:kBoldFont(14)];
        
        self.lbSymbol.text = [NSString stringWithFormat:@"%@\n\n%@", NSLocalizedString(@"币种", nil), subModel.coin];
        self.lbSymbol.attributedText = [self.lbSymbol.text attributedStringWithSubString:subModel.coin subColor:kRGB(16, 16, 16) subFont:kBoldFont(14)];
    }
}

@end
