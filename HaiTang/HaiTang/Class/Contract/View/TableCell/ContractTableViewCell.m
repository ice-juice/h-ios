//
//  ContractTableViewCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ContractTableViewCell.h"

@interface ContractTableViewCell ()
@property (strong, nonatomic) UILabel *lbPrice;
@property (strong, nonatomic) UILabel *lbNumber;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIView *colorView;

@end

@implementation ContractTableViewCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.frame = CGRectMake(0, 0, kScreenWidth, 26);
    self.progressView.progressTintColor = kRGBAlpha(255, 255, 255, 1);      //填充部分的颜色
    self.progressView.trackTintColor = kRGB(68, 188, 167);         //未填充部分的颜色
    self.progressView.transform = CGAffineTransformMakeScale(1.0, 13.0);
    [self.contentView addSubview:self.progressView];

    self.lbPrice = [UILabel labelWithText:@"0.00" textColor:kRGB(68, 188, 167) font:kFont(12)];
    [self.contentView addSubview:self.lbPrice];
    [self.lbPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.centerY.equalTo(0);
    }];
    
    self.lbNumber = [UILabel labelWithText:@"0.000000" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:self.lbNumber];
    [self.lbNumber makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(0);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSArray class]]) {
        NSString *numberStr = [NSString stringWithFormat:@"%@", model[1]];
        
        self.lbNumber.text = [NSString stringWithFormat:@"%.4f", [numberStr floatValue]];
        
        //需要保留的小数点位数
        NSInteger number = [self.number integerValue];
        NSString *format = [NSString stringWithFormat:@"%%.%ldf", number];
        self.lbPrice.text = [NSString stringWithFormat:format, [model[0] floatValue]];
        self.lbPrice.textColor = [self.type isEqualToString:@"buy"] ? kRGB(68, 188, 167) : kRGB(205, 61, 88);
        
//        CGFloat constant = self.frame.size.width * ([numberStr floatValue] / self.maxNumber);
//        if (isnan(constant)) {
//            constant = 0.0000;
//        }
//        if (isinf(constant)) {
//            constant = 0.0000;
//        }
//        self.colorViewWidth.constant = constant;
//        self.colorView.backgroundColor = [self.type isEqualToString:@"buy"] ? kRGBAlpha(198, 235, 228, 1) : kRGBAlpha(252, 199, 210, 1);;
        
        CGFloat progress = 1 - ([numberStr floatValue] / self.maxNumber) == 0 ? 1 : ([numberStr floatValue] / self.maxNumber);
        
        self.progressView.progress = progress;
        self.progressView.trackTintColor = [self.type isEqualToString:@"buy"] ? kRGBAlpha(198, 235, 228, 1) : kRGBAlpha(252, 199, 210, 1);
//
    }
}

@end
