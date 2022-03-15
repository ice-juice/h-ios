//
//  FiatOrderDetailTableFooterView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/28.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderDetailTableFooterView.h"

#import "OrderModel.h"

@interface FiatOrderDetailTableFooterView ()
@property (nonatomic, strong) UIButton *btnAppeal;
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UILabel *lbTip;

@end

@implementation FiatOrderDetailTableFooterView
#pragma mark - Event Response
- (void)onBtnWithAppealEvent:(UIButton *)btn {
    //申诉
    if (self.onBtnWithAppealBlock) {
        self.onBtnWithAppealBlock();
    }
}

- (void)onBtnWithCancelOrderEvent:(UIButton *)btn {
    //取消订单
    if (self.onBtnWithCancelOrderBlock) {
        self.onBtnWithCancelOrderBlock();
    }
}

- (void)onBtnWithPaidEvent:(UIButton *)btn {
    //已完成付款
    if (self.onBtnWithFinishPayBlock) {
        self.onBtnWithFinishPayBlock();
    }
}

- (void)onBtnWithPutMoneyEvent:(UIButton *)btn {
    //放币
    if (self.onBtnWithPutMoneyBlock) {
        self.onBtnWithPutMoneyBlock();
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    self.btnAppeal = [UIButton buttonWithTitle:NSLocalizedString(@"申诉", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithAppealEvent:)];
    self.btnAppeal.backgroundColor = kRGB(0, 102, 237);
    self.btnAppeal.layer.cornerRadius = 4;
    self.btnAppeal.hidden = YES;
    [self addSubview:self.btnAppeal];
    [self.btnAppeal makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    
    self.btnLeft = [UIButton buttonWithTitle:nil titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:nil selector:nil];
    self.btnLeft.backgroundColor = [UIColor clearColor];
    self.btnLeft.layer.cornerRadius = 2;
    self.btnLeft.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnLeft.layer.borderWidth = 1;
    self.btnLeft.hidden = YES;
    [self addSubview:self.btnLeft];
    [self.btnLeft makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(40);
        make.left.equalTo(15);
        make.height.equalTo(34);
        make.width.equalTo((kScreenWidth - 55) / 2);
    }];
    
    self.btnRight = [UIButton buttonWithTitle:nil titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:nil selector:nil];
    self.btnRight.layer.cornerRadius = 2;
    self.btnRight.backgroundColor = kRGB(0, 102, 237);
    self.btnRight.hidden = YES;
    [self addSubview:self.btnRight];
    [self.btnRight makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnLeft);
        make.right.equalTo(-15);
        make.width.height.equalTo(self.btnLeft);
    }];
    
    self.lbTip = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    self.lbTip.hidden = YES;
    [self addSubview:self.lbTip];
    [self.lbTip makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(89);
        make.centerX.equalTo(0);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[OrderModel class]]) {
        OrderModel *orderModel = model;
        for (UIView *subView in self.subviews) {
            subView.hidden = YES;
        }
        if ([orderModel.status isEqualToString:@"WAIT"]) {
            if ([orderModel.pageType isEqualToString:@"BUY"]) {
                //购买订单-待付款
                self.lbTip.hidden = NO;
                [self setButton:self.btnLeft title:NSLocalizedString(@"取消订单", nil) selector:@selector(onBtnWithCancelOrderEvent:)];
                [self setButton:self.btnRight title:NSLocalizedString(@"已完成付款", nil) selector:@selector(onBtnWithPaidEvent:)];
                self.lbTip.text = NSLocalizedString(@"请在倒计时结束前向卖家付款，否则订单将自动取消", nil);
            }
        } else if ([orderModel.status isEqualToString:@"APPEAL"]) {
            //申诉中
            NSString *content = @"";
            if ([orderModel.pageType isEqualToString:@"BUY"]) {
                //购买订单
                content = orderModel.content;
            } else {
                //出售订单
                content = orderModel.content1;
            }
            if ([NSString isEmpty:content]) {
                self.btnAppeal.hidden = NO;
            } else {
                self.btnAppeal.hidden = YES;
            }
            
        } else if ([orderModel.status isEqualToString:@"WAIT_COIN"]) {
            if ([orderModel.pageType isEqualToString:@"SELL"]) {
                //出售订单 - 待放币
                self.lbTip.hidden = YES;
//                self.lbTip.text = NSLocalizedString(@"如倒计时结束仍未收到卖家放币，请发起申述", nil);
                [self setButton:self.btnLeft title:NSLocalizedString(@"申诉", nil) selector:@selector(onBtnWithAppealEvent:)];
                [self setButton:self.btnRight title:NSLocalizedString(@"放币", nil) selector:@selector(onBtnWithPutMoneyEvent:)];
            } else {
                //购买订单-已付款
                self.lbTip.hidden = NO;
                self.btnAppeal.hidden = NO;
                self.lbTip.text = NSLocalizedString(@"如倒计时结束仍未收到卖家放币，请发起申述", nil);
            }
        }
    }
}

#pragma mark - Private Method
- (void)setButton:(UIButton *)button title:(NSString *)title selector:(SEL)selector {
    button.hidden = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
