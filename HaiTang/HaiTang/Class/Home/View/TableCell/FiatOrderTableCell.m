//
//  FiatOrderTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderTableCell.h"

#import "OrderModel.h"

@interface FiatOrderTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbVolume;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;


@end

@implementation FiatOrderTableCell
#pragma mark - Super Class
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[OrderModel class]]) {
        OrderModel *orderModel = model;
        NSString *type = [orderModel.pageType isEqualToString:@"BUY"] ? @"购买" : @"出售";
        self.lbName.text = [NSString stringWithFormat:@"%@USDT", NSLocalizedString(type, nil)];
        
        NSString *status = @"";
        if ([orderModel.status isEqualToString:@"FINISH"]) {
            //已完成
            status = @"已完成";
        } else if ([orderModel.status isEqualToString:@"WAIT"]) {
            //待付款、待收款
            if ([orderModel.pageType isEqualToString:@"BUY"]) {
                status = @"待付款";
            } else {
                status = @"待收款";
            }
        } else if ([orderModel.status isEqualToString:@"WAIT_COIN"]) {
            //待放币、已付款
            if ([orderModel.pageType isEqualToString:@"BUY"]) {
                status = @"已付款";
            } else {
                status = @"待放币";
            }
        } else if ([orderModel.status isEqualToString:@"CANCEL"]) {
            //已取消
            status = @"已取消";
        } else if ([orderModel.status isEqualToString:@"APPEAL"]) {
            //申诉中
            status = @"申诉中";
        } else if ([orderModel.status isEqualToString:@"Y"]) {
            //挂单中
            status = @"挂单中";
        } else if ([orderModel.status isEqualToString:@"N"]) {
            //已撤单
            status = @"已撤单";
        }
        
        self.lbStatus.text = NSLocalizedString(status, nil);
        self.lbNumber.text = [NSString stringWithFormat:@"%.4f", [orderModel.number floatValue]];
        
        NSString *volume = [NSString isEmpty:orderModel.totalPrice] ? orderModel.cny : orderModel.totalPrice;
        self.lbVolume.text = [NSString stringWithFormat:@"%.2f", [volume floatValue]];
        
        self.lbTime.text = orderModel.createTime;
    }
}

@end
