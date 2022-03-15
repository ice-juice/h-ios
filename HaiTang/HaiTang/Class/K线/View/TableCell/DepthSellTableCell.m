//
//  DepthSellTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "DepthSellTableCell.h"

#import "TradeListSubModel.h"

@interface DepthSellTableCell ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *lbIndex;
@property (weak, nonatomic) IBOutlet UILabel *lbNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@end

@implementation DepthSellTableCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.progressView.transform = CGAffineTransformMakeScale(1, 1);
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[TradeListSubModel class]]) {
        TradeListSubModel *subModel = model;
        self.lbNumber.text = [NSString stringWithFormat:@"%.1f", [subModel.number floatValue]];
        self.lbIndex.text = [NSString stringWithFormat:@"%ld", subModel.index];
        self.lbPrice.text = [NSString stringWithFormat:@"%.1f", [subModel.price floatValue]];
        
//        self.progressView.progress = ((subModel.max - [subModel.price floatValue]) / (subModel.max - subModel.min)) == 1 ? 0.01 : ((subModel.max - [subModel.price floatValue]) / (subModel.max - subModel.min));
        
        self.progressView.progress = (1 - ((subModel.max - subModel.price.floatValue) / (subModel.max - subModel.min))) == 0 ? 0.01 : (1 - ((subModel.max - subModel.price.floatValue) / (subModel.max - subModel.min)));
        
//        self.progressView.progress = 1 - ((subModel.price.floatValue - subModel.min) / (subModel.max - subModel.min)) == 0 ? 0.99 : 1 - ((subModel.price.floatValue - subModel.min) / (subModel.max - subModel.min));

    }
}

@end
