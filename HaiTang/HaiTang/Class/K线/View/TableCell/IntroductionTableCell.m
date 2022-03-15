//
//  IntroductionTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "IntroductionTableCell.h"

#import "TradeListSubModel.h"

@interface IntroductionTableCell ()
@property (nonatomic, strong) UILabel *lbSymbol;
@property (nonatomic, strong) UILabel *lbValue;
@property (nonatomic, strong) UILabel *lbMinPrice;

@end

@implementation IntroductionTableCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    self.lbSymbol = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:kFont(14)];
    [self addSubview:self.lbSymbol];
    [self.lbSymbol makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.left.equalTo(15);
    }];
    
    UILabel *lbMaturity = [UILabel labelWithText:NSLocalizedString(@"到期", nil) textColor:kRGB(125, 145, 171) font:kFont(14)];
    [self addSubview:lbMaturity];
    [lbMaturity makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbSymbol.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    UILabel *lbSubMaturity = [UILabel labelWithText:NSLocalizedString(@"永续", nil) textColor:[UIColor whiteColor] font:kFont(14)];
    [self addSubview:lbSubMaturity];
    [lbSubMaturity makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(lbMaturity);
    }];
    
    UILabel *lbJiJia = [UILabel labelWithText:NSLocalizedString(@"计价货币", nil) textColor:kRGB(125, 145, 171) font:kFont(14)];
    [self addSubview:lbJiJia];
    [lbJiJia makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbMaturity.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    UILabel *lbSubJiJia = [UILabel labelWithText:NSLocalizedString(@"USDT", nil) textColor:[UIColor whiteColor] font:kFont(14)];
    [self addSubview:lbSubJiJia];
    [lbSubJiJia makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(lbJiJia);
    }];
    
    UILabel *lbJieSuan = [UILabel labelWithText:NSLocalizedString(@"结算货币", nil) textColor:kRGB(125, 145, 171) font:kFont(14)];
    [self addSubview:lbJieSuan];
    [lbJieSuan makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbJiJia.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    UILabel *lbSubJieSuan = [UILabel labelWithText:NSLocalizedString(@"USDT", nil) textColor:[UIColor whiteColor] font:kFont(14)];
    [self addSubview:lbSubJieSuan];
    [lbSubJieSuan makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(lbJieSuan);
    }];
    
    UILabel *lbSize = [UILabel labelWithText:NSLocalizedString(@"合约大小", nil) textColor:kRGB(125, 145, 171) font:kFont(14)];
    [self addSubview:lbSize];
    [lbSize makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbJieSuan.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbValue = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:kFont(14)];
    [self addSubview:self.lbValue];
    [self.lbValue makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(lbSize);
    }];
    
    UILabel *lbMinPrice = [UILabel labelWithText:NSLocalizedString(@"最小价格变动", nil) textColor:kRGB(125, 145, 171) font:kFont(14)];
    [self addSubview:lbMinPrice];
    [lbMinPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbSize.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbMinPrice = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:kFont(14)];
    [self addSubview:self.lbMinPrice];
    [self.lbMinPrice makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(lbMinPrice);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[TradeListSubModel class]]) {
        TradeListSubModel *subModel = model;
        self.lbSymbol.text = [NSString stringWithFormat:@"%@%@ %@", subModel.symbol, NSLocalizedString(@"永续", nil), NSLocalizedString(@"正向永续", nil)];
        
        NSString *symbol = [subModel.symbol substringToIndex:subModel.symbol.length - 5];
        self.lbValue.text = [NSString stringWithFormat:@"%@%@/%@", subModel.handNumber, symbol, NSLocalizedString(@"手", nil)];
        
        self.lbMinPrice.text = [NSString stringWithFormat:@"%.8f", [subModel.price floatValue]];
    }
}

@end
