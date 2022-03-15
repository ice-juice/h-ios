//
//  WithdrawPopupView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "WithdrawPopupView.h"

@interface WithdrawPopupView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imgView0;
@property (nonatomic, strong) UIImageView *imgView1;
@property (nonatomic, strong) UILabel *lbTitle1;

@end

@implementation WithdrawPopupView
#pragma mark - Event Response
- (void)onBtnWithGoSafetyEvent:(UIButton *)btn {
    //前往安全设置
    if (self.onGoSafetyBlock) {
        self.onGoSafetyBlock();
    }
    [self closeView];
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1;
    backgroundView.userInteractionEnabled = YES;
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)]];
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
        make.height.equalTo(233);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"jg"]];
    [self.contentView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(34);
        make.centerX.equalTo(0);
        make.top.equalTo(15);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"为了您的资产安全，请您：", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(14)];
    [self.contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(20);
        make.centerX.equalTo(0);
    }];
    
    self.imgView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zctk-wxz-2"]];
    [self.contentView addSubview:self.imgView0];
    [self.imgView0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(12);
        make.top.equalTo(lbTitle.mas_bottom).offset(19);
        make.left.equalTo(lbTitle).offset(37);
    }];
    
    UILabel *lbTitle0 = [UILabel labelWithText:NSLocalizedString(@"设置资产密码", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self.contentView addSubview:lbTitle0];
    [lbTitle0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView0);
        make.left.equalTo(self.imgView0.mas_right).offset(10);
    }];
    
    self.imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zctk-wxz-2"]];
    [self.contentView addSubview:self.imgView1];
    [self.imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(12);
        make.top.equalTo(self.imgView0.mas_bottom).offset(23);
        make.left.equalTo(self.imgView0);
    }];
    
    self.lbTitle1 = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self.contentView addSubview:self.lbTitle1];
    [self.lbTitle1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView1);
        make.left.equalTo(self.imgView1.mas_right).offset(10);
    }];
    
    UIButton *btnGo = [UIButton buttonWithTitle:NSLocalizedString(@"前往安全设置", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnWithGoSafetyEvent:)];
    btnGo.layer.cornerRadius = 2;
    btnGo.layer.borderColor = kRGB(0, 102, 237).CGColor;
    btnGo.layer.borderWidth = 1;
    [self.contentView addSubview:btnGo];
    [btnGo makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-20);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(34);
    }];
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(30, (kScreenHeight - 233) / 2, kScreenWidth - 60, 233)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(30, (kScreenHeight - 233) / 2, kScreenWidth - 60, 233)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}

#pragma mark - Setter & Getter
- (void)setImgName0:(NSString *)imgName0 {
    if (imgName0) {
        _imgName0 = imgName0;
        self.imgView0.image = [UIImage imageNamed:imgName0];
    }
}

- (void)setImgName1:(NSString *)imgName1 {
    if (imgName1) {
        _imgName1 = imgName1;
        self.imgView1.image = [UIImage imageNamed:imgName1];
    }
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        self.lbTitle1.text = NSLocalizedString(title, nil);
    }
}

@end
