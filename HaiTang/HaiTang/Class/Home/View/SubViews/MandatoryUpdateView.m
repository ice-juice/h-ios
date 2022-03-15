//
//  MandatoryUpdateView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "MandatoryUpdateView.h"

@interface MandatoryUpdateView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *lbContent;

@end

@implementation MandatoryUpdateView
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
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.layer.cornerRadius = 12;
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.left.equalTo(30);
        make.right.equalTo(-30);
        make.height.equalTo(357);
    }];
    
    UIImageView *imgViewBackground = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"xtgx"]];
    [self.contentView addSubview:imgViewBackground];
    [imgViewBackground makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(221);
    }];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(158.5);
        make.left.right.bottom.equalTo(0);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"更新内容：", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(14)];
    [whiteView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(33.5);
        make.left.equalTo(20);
    }];
    
    self.lbContent = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
    self.lbContent.numberOfLines = 0;
    [whiteView addSubview:self.lbContent];
    [self.lbContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(20);
        make.left.equalTo(20);
        make.right.equalTo(-20);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithTitle:NSLocalizedString(@"取消", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnCancelEvent:)];
    btnCancel.layer.cornerRadius = 2;
    btnCancel.layer.borderColor = kRGB(0, 102, 237).CGColor;
    btnCancel.layer.borderWidth = 0.5;
    [whiteView addSubview:btnCancel];
    [btnCancel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.bottom.equalTo(-27);
        make.width.equalTo(125);
        make.height.equalTo(34);
    }];
    
    UIButton *btnSure = [UIButton buttonWithTitle:NSLocalizedString(@"立即更新", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnUpdateEvent:)];
    btnSure.layer.cornerRadius = 2;
    btnSure.backgroundColor = kRGB(0, 102, 237);
    [whiteView addSubview:btnSure];
    [btnSure makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.bottom.equalTo(-27);
        make.width.equalTo(125);
        make.height.equalTo(34);
    }];
}

- (void)showViewWithContent:(NSString *)content {
    self.lbContent.text = content;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(30, (kScreenHeight - 357) / 2, kScreenWidth - 60, 357)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(30, (kScreenHeight - 357) / 2, kScreenWidth - 60, 357)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}


#pragma mark - Event Response
- (void)onBtnCancelEvent:(UIButton *)btn {
    [self closeView];
    exit(0);
}

- (void)onBtnUpdateEvent:(UIButton *)btn {
    if (self.onBtnWithUpdateVersionBlock) {
        self.onBtnWithUpdateVersionBlock();
    }
    [self closeView];
}

@end
