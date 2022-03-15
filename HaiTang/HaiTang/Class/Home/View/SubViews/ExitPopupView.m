//
//  ExitPopupView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ExitPopupView.h"

@interface ExitPopupView ()
@property (nonatomic, strong) UIView *contentView;

@end

@implementation ExitPopupView
#pragma mark - Event Response
- (void)onBtnWithExitEvent:(UIButton *)btn {
    //退出登录
    if (self.onBtnWithLogoutBlock) {
        self.onBtnWithLogoutBlock();
    }
    [self closeView];
}

- (void)onBtnWithCancelEvent:(UIButton *)btn {
    //取消
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
        make.left.right.equalTo(0);
        make.bottom.equalTo(20);
        make.height.equalTo(169);
    }];
    
    UIButton *btnExit = [UIButton buttonWithTitle:NSLocalizedString(@"退出登录", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kBoldFont(14) target:self selector:@selector(onBtnWithExitEvent:)];
    [self.contentView addSubview:btnExit];
    [btnExit makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(50);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(50);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithTitle:NSLocalizedString(@"取消", nil) titleColor:[UIColor blueColor] highlightedTitleColor:[UIColor blueColor] font:kBoldFont(14) target:self selector:@selector(onBtnWithCancelEvent:)];
    [self.contentView addSubview:btnCancel];
    [btnCancel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(45);
    }];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = kRGB(236, 236, 236);
    [self.contentView addSubview:lineView1];
    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(45);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
    }];
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 169)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, kScreenHeight - 169, kScreenWidth, 169)];
    }];
}

- (void)closeView {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 169)];
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
