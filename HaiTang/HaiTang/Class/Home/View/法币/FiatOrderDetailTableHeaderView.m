//
//  FiatOrderDetailTableHeaderView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderDetailTableHeaderView.h"

#import "OrderModel.h"

@interface FiatOrderDetailTableHeaderView ()
@property (nonatomic, strong) UIImageView *imgViewIcon;
@property (nonatomic, strong) UILabel *lbStatus;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbPriceTitle;
@property (nonatomic, strong) UILabel *lbNumberTitle;
@property (nonatomic, strong) UILabel *lbAmountTitle;
@property (nonatomic, strong) UILabel *lbPrice;
@property (nonatomic, strong) UILabel *lbNumber;
@property (nonatomic, strong) UILabel *lbAmount;

@end

@implementation FiatOrderDetailTableHeaderView
#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = kRGB(0, 125, 255);
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(152);
    }];
    
    self.imgViewIcon = [[UIImageView alloc] init];
    self.imgViewIcon.contentMode = UIViewContentModeScaleAspectFit;
    [backgroundView addSubview:self.imgViewIcon];
    [self.imgViewIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(-15);
        make.width.equalTo(137);
        make.height.equalTo(130);
    }];
    
    self.lbStatus = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
    [backgroundView addSubview:self.lbStatus];
    [self.lbStatus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
    }];
    
    self.lbTitle = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:kBoldFont(12)];
    [backgroundView addSubview:self.lbTitle];
    [self.lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbStatus.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.btnCountDown = [UIButton buttonWithTitle:@"" titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kBoldFont(18) target:nil selector:nil];
    [self.btnCountDown setImage:[StatusHelper imageNamed:@"dd-djs"] forState:UIControlStateNormal];
    self.btnCountDown.hidden = YES;
    self.btnCountDown.userInteractionEnabled = NO;
    [backgroundView addSubview:self.btnCountDown];
    [self.btnCountDown makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(self.lbTitle);
        make.width.equalTo(100);
        make.height.equalTo(30);
    }];
    [self.btnCountDown setTitleRightSpace:8];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4;
    [self addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(108);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(107);
    }];
    
    self.lbPriceTitle = [UILabel labelWithText:@"" textColor:kRGB(153, 153, 153) font:kFont(12)];
    [contentView addSubview:self.lbPriceTitle];
    [self.lbPriceTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.left.equalTo(15);
    }];
    
    self.lbPrice = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [contentView addSubview:self.lbPrice];
    [self.lbPrice makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbPriceTitle);
        make.right.equalTo(-15);
    }];
    
    self.lbNumberTitle = [UILabel labelWithText:@"" textColor:kRGB(153, 153, 153) font:kFont(12)];
    [contentView addSubview:self.lbNumberTitle];
    [self.lbNumberTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbPriceTitle.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbNumber = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [contentView addSubview:self.lbNumber];
    [self.lbNumber makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbNumberTitle);
        make.right.equalTo(-15);
    }];
    
    self.lbAmountTitle = [UILabel labelWithText:@"" textColor:kRGB(153, 153, 153) font:kFont(12)];
    [contentView addSubview:self.lbAmountTitle];
    [self.lbAmountTitle makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-16);
        make.left.equalTo(15);
    }];
    
    self.lbAmount = [UILabel labelWithText:@"" textColor:kRGB(205, 61, 88) font:kBoldFont(20)];
    [contentView addSubview:self.lbAmount];
    [self.lbAmount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbAmountTitle);
        make.right.equalTo(-15);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[OrderModel class]]) {
        OrderModel *orderModel = model;
        self.btnCountDown.hidden = YES;
        if ([orderModel.pageType isEqualToString:@"BUY"]) {
            //购买订单
            self.lbPriceTitle.text = NSLocalizedString(@"购买单价", nil);
            self.lbNumberTitle.text = NSLocalizedString(@"购买数量", nil);
            self.lbAmountTitle.text = NSLocalizedString(@"订单金额", nil);
        } else {
            //出售订单
            self.lbPriceTitle.text = NSLocalizedString(@"出售单价", nil);
            self.lbNumberTitle.text = NSLocalizedString(@"出售数量", nil);
            self.lbAmountTitle.text = NSLocalizedString(@"订单金额", nil);
        }
        
        self.lbPrice.text = [NSString stringWithFormat:@"$%.2f", [orderModel.unitPrice floatValue]];
        self.lbNumber.text = [NSString stringWithFormat:@"%.2f USDT", [orderModel.number floatValue]];
        self.lbAmount.text = [NSString stringWithFormat:@"$%.2f", [orderModel.cny floatValue]];
        
        if ([orderModel.status isEqualToString:@"WAIT"]) {
            //待付款、待收款
            self.btnCountDown.hidden = NO;
            self.imgViewIcon.image = [StatusHelper imageNamed:@"dd-dfk"];
            if ([orderModel.pageType isEqualToString:@"BUY"]) {
                //购买订单-待付款
                self.lbStatus.text = NSLocalizedString(@"待付款", nil);
                self.lbTitle.text = NSLocalizedString(@"购买USDT 下单成功请向卖家付款", nil);
            } else {
                //出售订单-待收款
                self.lbStatus.text = NSLocalizedString(@"待收款", nil);
                self.lbTitle.text = NSLocalizedString(@"出售USDT 买家已下单等待买家付款", nil);
            }
        } else if ([orderModel.status isEqualToString:@"CANCEL"]) {
            //已取消
            self.lbStatus.text = NSLocalizedString(@"已取消", nil);
            if ([orderModel.pageType isEqualToString:@"BUY"]) {
                self.lbTitle.text = NSLocalizedString(@"购买USDT 该订单已取消", nil);
            } else {
                self.lbTitle.text = NSLocalizedString(@"出售USDT 该订单已取消", nil);
            }
            self.imgViewIcon.image = [StatusHelper imageNamed:@"dd-yqx"];
            
        } else if ([orderModel.status isEqualToString:@"APPEAL"]) {
            //申诉中
            self.lbStatus.text = NSLocalizedString(@"申诉中", nil);
            self.lbTitle.text = NSLocalizedString(@"订单申诉中 请耐心等待客服处理", nil);
            self.imgViewIcon.image = [StatusHelper imageNamed:@"dd-ssz"];
        } else if ([orderModel.status isEqualToString:@"WAIT_COIN"]) {
            self.btnCountDown.hidden = NO;
            self.imgViewIcon.image = [StatusHelper imageNamed:@"dd-yfk"];
            if ([orderModel.pageType isEqualToString:@"BUY"]) {
                //购买订单-已付款
                self.lbStatus.text = NSLocalizedString(@"已付款", nil);
                self.lbTitle.text = NSLocalizedString(@"购买USDT 您已付款等待卖家放币", nil);
            } else {
                //出售订单-待放币
                self.lbStatus.text = NSLocalizedString(@"待放币", nil);
                self.lbTitle.text = NSLocalizedString(@"出售USDT 买家已付款请核查收款确认后放币", nil);
            }
        } else if ([orderModel.status isEqualToString:@"FINISH"]) {
            //已完成
            self.lbStatus.text = NSLocalizedString(@"已完成", nil);
            if ([orderModel.pageType isEqualToString:@"BUY"]) {
                self.lbTitle.text = NSLocalizedString(@"购买USDT 该订单已完成", nil);
            } else {
                self.lbTitle.text = NSLocalizedString(@"出售USDT 该订单已完成", nil);
            }
            self.imgViewIcon.image = [StatusHelper imageNamed:@"dd-ywc"];
        }
    }
}

@end
