//
//  DepthViewCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "DepthViewCell.h"
#import "TradeListSubModel.h"

@interface DepthViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbLeft;
@property (weak, nonatomic) IBOutlet UILabel *lbCenter;
@property (weak, nonatomic) IBOutlet UILabel *lbRight;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation DepthViewCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.progressView.transform = CGAffineTransformMakeScale(1, 1);
    self.progressView.progressTintColor = kRGB(3, 14, 30);
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[TradeListSubModel class]]) {
        TradeListSubModel *subModel = model;
        self.lbCenter.text = [NSString stringWithFormat:@"%.1f", [subModel.number floatValue]];
        self.lbLeft.text = [NSString stringWithFormat:@"%ld", subModel.index];
        self.lbRight.text = [NSString stringWithFormat:@"%.1f", [subModel.price floatValue]];
        
        self.progressView.trackTintColor = kRGB(3, 62, 64);
//        self.progressView.progress = 1-(([subModel.price floatValue] - subModel.min)/(subModel.max-subModel.min)) == 1 ? 0.99:1-(([subModel.price floatValue] - subModel.min)/(subModel.max-subModel.min));
        
        //（最高价 - 委托价）/ （最高价 - 最低价）
        self.progressView.progress = 1 - ((subModel.max - subModel.price.floatValue) / (subModel.max - subModel.min)) == 1 ? 0.99 : 1 - ((subModel.max - subModel.price.floatValue) / (subModel.max - subModel.min));
    }
}

@end
