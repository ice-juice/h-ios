//
//  FiatTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatTableCell.h"
#import "OrderModel.h"

@interface FiatTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbCNY;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewMethod;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnMethod;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) OrderModel *orderModel;

@end

@implementation FiatTableCell
#pragma mark - Event Response
- (IBAction)onBtnWithMethodEvent:(UIButton *)sender {
    //下单
    if (self.onBtnWithPlaceOnOrderBlock) {
        self.onBtnWithPlaceOnOrderBlock(self.orderModel);
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.bgView.layer.cornerRadius = 7;
    self.btnMethod.layer.cornerRadius = 2;
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[OrderModel class]]) {
        self.orderModel = model;
        self.lbName.text = self.orderModel.nickName;
        self.lbNumber.text = [NSString stringWithFormat:@"%@(USDT)：%.4f", NSLocalizedString(@"数量", nil), [self.orderModel.restNumber floatValue]];
        UIColor *textColor = [self.orderModel.orderType isEqualToString:@"0"] ? kRGB(3, 173, 143) : kRGB(205, 61, 88);
        
        //限额范围，第一个数字=单笔最低购买(出售)金额，第二个数字=当前剩余数量*单价，单位CNY
        CGFloat min = [self.orderModel.lowPrice floatValue];
        CGFloat max = [self.orderModel.restNumber floatValue] * [self.orderModel.unitPrice floatValue];
        self.lbCNY.text = [NSString stringWithFormat:@"%@(USD)：%.4f-%.4f", NSLocalizedString(@"限额", nil), min, max];
        
        self.imgViewMethod.image = [UIImage imageNamed:self.orderModel.payMethodImgName];
        self.lbPrice.text = [NSString stringWithFormat:@"$%.2f", [self.orderModel.unitPrice floatValue]];
        self.lbPrice.textColor = textColor;
        
        NSString *btnTitle = [self.orderModel.orderType isEqualToString:@"0"] ? @"购买" : @"出售";
        self.btnMethod.backgroundColor = textColor;
        [self.btnMethod setTitle:NSLocalizedString(btnTitle, nil) forState:UIControlStateNormal];
    }
}

@end
