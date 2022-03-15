//
//  NewDealViewCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NewDealViewCell.h"

#import "TradeListSubModel.h"

@interface NewDealViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbDirect;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@end

@implementation NewDealViewCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[TradeListSubModel class]]) {
        TradeListSubModel *subModel = model;
        
        self.lbDirect.text = [subModel.direction isEqualToString:@"sell"] ? NSLocalizedString(@"卖", nil) : NSLocalizedString(@"买", nil);
        self.lbDirect.textColor = [subModel.direction isEqualToString:@"sell"] ? kRGB(205, 61, 88) : kRGB(3, 173, 143);
        
        self.lbPrice.text = [NSString stringWithFormat:@"%.1f", [subModel.price floatValue]];
        self.lbPrice.textColor = self.lbDirect.textColor;
        
        self.lbNumber.text = subModel.amount;
        
        //时间戳转时间
        long long time = [subModel.ts longLongValue] / 1000;
        NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
        //设置时间格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat:@"HH:mm:ss"];
        //将时间转换为字符串
        NSString *timeStr = [formatter stringFromDate:myDate];
        self.lbTime.text = timeStr;
    }
}

@end
