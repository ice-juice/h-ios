//
//  StopLossPopupView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "StopLossPopupView.h"

@interface StopLossPopupView ()
@property (nonatomic, strong) UITextField *tfProfitPrice;
@property (nonatomic, strong) UITextField *tfLossPrice;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation StopLossPopupView
#pragma mark - Event Response
- (void)onBtnCancelEvent:(UIButton *)btn {
    [self closeView];
}

- (void)onBtnSureEvent:(UIButton *)btn {
    NSString *profitPrice = @"";
    NSString *lossPrice = @"";
    if (![NSString isEmpty:self.tfProfitPrice.text]) {
        profitPrice = self.tfProfitPrice.text;
    }
    if (![NSString isEmpty:self.tfLossPrice.text]) {
        lossPrice = self.tfLossPrice.text;
    }
    if (self.onBtnSetTakeProfitAndStopLossBlock) {
        self.onBtnSetTakeProfitAndStopLossBlock(profitPrice, lossPrice);
    }
    [self closeView];
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1;
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12;
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.left.equalTo(30);
        make.height.equalTo(315);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"止盈止损", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(18)];
    [self.contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(40);
        make.centerX.equalTo(0);
    }];
    
    UILabel *lbProfitT = [UILabel labelWithText:NSLocalizedString(@"止盈价", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self.contentView addSubview:lbProfitT];
    [lbProfitT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(20);
        make.left.equalTo(20);
    }];
    
    self.tfProfitPrice = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"输入止盈价格", nil) hasLine:YES];
    self.tfProfitPrice.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:self.tfProfitPrice];
    [self.tfProfitPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbProfitT.mas_bottom).offset(5);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(40);
    }];
    
    UILabel *lbLossT = [UILabel labelWithText:NSLocalizedString(@"止损价", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self.contentView addSubview:lbLossT];
    [lbLossT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfProfitPrice.mas_bottom).offset(20);
        make.left.equalTo(20);
    }];
    
    self.tfLossPrice = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"输入止损价格", nil) hasLine:YES];
    self.tfLossPrice.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:self.tfLossPrice];
    [self.tfLossPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbLossT.mas_bottom).offset(5);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(40);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithTitle:NSLocalizedString(@"再想想", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnCancelEvent:)];
    btnCancel.layer.cornerRadius = 2;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = kRGB(0, 102, 237).CGColor;
    [self.contentView addSubview:btnCancel];
    [btnCancel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-23);
        make.left.equalTo(20);
        make.width.equalTo(125);
        make.height.equalTo(34);
    }];
    
    UIButton *btnSure = [UIButton buttonWithTitle:NSLocalizedString(@"确定", nil) titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(255, 255, 255) font:kFont(14) target:self selector:@selector(onBtnSureEvent:)];
    btnSure.layer.cornerRadius = 2;
    btnSure.backgroundColor = kRGB(0, 102, 237);
    [self.contentView addSubview:btnSure];
    [btnSure makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-23);
        make.right.equalTo(-20);
        make.width.equalTo(125);
        make.height.equalTo(34);
    }];
    
}

- (void)showView {
    self.tfProfitPrice.text = @"";
    self.tfLossPrice.text = @"";
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth - 60, 315)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, (kScreenHeight - 315) / 2, kScreenWidth - 60, 315)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}

@end
