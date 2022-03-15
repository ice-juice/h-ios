//
//  MarginPopupView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "MarginPopupView.h"

@interface MarginPopupView ()
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *btnYes;
@property (nonatomic, strong) UIButton *btnNo;

@property (nonatomic, assign) PopupType popupType;

@end

@implementation MarginPopupView
#pragma mark - Event Response
- (void)onBtnWithYesEvent:(UIButton *)btn {
    if (self.onBtnWithYesBlock) {
        self.onBtnWithYesBlock();
    }
    [self closeView];
}

- (void)onBtnWithNoEvent:(UIButton *)btn {
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
        make.right.equalTo(-30);
        make.height.equalTo(195);
    }];
    
    UIImageView *imgViewTip = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"jg"]];
    [self.contentView addSubview:imgViewTip];
    [imgViewTip makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(34);
        make.top.equalTo(15);
        make.centerX.equalTo(0);
    }];
    
    self.lbTitle = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kBoldFont(14)];
    self.lbTitle.numberOfLines = 0;
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.lbTitle];
    [self.lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgViewTip.mas_bottom).offset(20);
        make.centerX.equalTo(0);
        make.left.equalTo(20);
        make.right.equalTo(-20);
    }];
    
    self.btnYes = [UIButton buttonWithTitle:@"" titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:nil selector:nil];
    self.btnYes.layer.cornerRadius = 2;
    self.btnYes.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnYes.layer.borderWidth = 1;
    [self.contentView addSubview:self.btnYes];
    [self.btnYes makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.bottom.equalTo(-27);
        make.height.equalTo(34);
        make.width.equalTo((kScreenWidth - 125) / 2);
    }];
    
    self.btnNo = [UIButton buttonWithTitle:@"" titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(255, 255, 255) font:kFont(14) target:nil selector:nil];
    self.btnNo.layer.cornerRadius = 2;
    self.btnNo.backgroundColor = kRGB(0, 102, 237);
    [self.contentView addSubview:self.btnNo];
    [self.btnNo makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.bottom.equalTo(-27);
        make.height.equalTo(34);
        make.width.equalTo((kScreenWidth - 125) / 2);
    }];
}

- (void)showViewWithPopupType:(PopupType)popupType {
    if (popupType == PopupTypeAuthentication) {
        //实名认证
        self.lbTitle.text = NSLocalizedString(@"需要完成实名认证", nil);
        [self setButton:self.btnYes title:NSLocalizedString(@"取消", nil) selector:@selector(onBtnWithNoEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"前往认证", nil) selector:@selector(onBtnWithYesEvent:)];
    } else if (popupType == PopupTypeReturn) {
        self.lbTitle.text = NSLocalizedString(@"退还押金后无法使用挂单功能是否退还", nil);
        [self setButton:self.btnYes title:NSLocalizedString(@"是", nil) selector:@selector(onBtnWithYesEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"否", nil) selector:@selector(onBtnWithNoEvent:)];
    } else if (popupType == PopupTypeBackUpDeposit) {
        self.lbTitle.text = NSLocalizedString(@"您的保证金不足，无法使用挂单功能，补缴后继续开通", nil);
        [self setButton:self.btnYes title:NSLocalizedString(@"暂不补缴", nil) selector:@selector(onBtnWithNoEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"前往补缴", nil) selector:@selector(onBtnWithYesEvent:)];
    } else if (popupType == PopupTypeCancelPendingBuyOrder) {
        self.lbTitle.text = NSLocalizedString(@"是否撤下该购买订单", nil);
        [self setButton:self.btnYes title:NSLocalizedString(@"是", nil) selector:@selector(onBtnWithYesEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"否", nil) selector:@selector(onBtnWithNoEvent:)];
    } else if (popupType == PopupTypeCancelPendingSellOrder) {
        self.lbTitle.text = NSLocalizedString(@"是否撤下该出售订单", nil);
        [self setButton:self.btnYes title:NSLocalizedString(@"是", nil) selector:@selector(onBtnWithYesEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"否", nil) selector:@selector(onBtnWithNoEvent:)];
    } else if (popupType == PopupTypeCancelContract) {
        self.lbTitle.text = NSLocalizedString(@"是否撤销当前委托订单", nil);
        [self setButton:self.btnYes title:NSLocalizedString(@"再想想", nil) selector:@selector(onBtnWithNoEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"撤销", nil) selector:@selector(onBtnWithYesEvent:)];
    } else if (popupType == PopupTypeCloseingAll) {
        self.lbTitle.text = NSLocalizedString(@"是否平仓全部持仓仓位", nil);
        [self setButton:self.btnYes title:NSLocalizedString(@"再想想", nil) selector:@selector(onBtnWithNoEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"全部平仓", nil) selector:@selector(onBtnWithYesEvent:)];
    } else if (popupType == PopupTypeCancelAllContract) {
        self.lbTitle.text = NSLocalizedString(@"是否撤销全部委托订单", nil);
        [self setButton:self.btnYes title:NSLocalizedString(@"再想想", nil) selector:@selector(onBtnWithNoEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"全部撤销", nil) selector:@selector(onBtnWithYesEvent:)];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth - 60, 195)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, (kScreenHeight - 195) / 2, kScreenWidth - 60, 195)];
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSString class]]) {
        self.lbTitle.text = model;
        [self setButton:self.btnYes title:NSLocalizedString(@"是", nil) selector:@selector(onBtnWithYesEvent:)];
        [self setButton:self.btnNo title:NSLocalizedString(@"否", nil) selector:@selector(onBtnWithNoEvent:)];
        [self showViewWithPopupType:PopupTypeCancelOrder];
    }
}

#pragma mark - Private Method
- (void)setButton:(UIButton *)button title:(NSString *)title selector:(SEL)selector {
    button.hidden = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeView {
    [self removeFromSuperview];
}

@end
