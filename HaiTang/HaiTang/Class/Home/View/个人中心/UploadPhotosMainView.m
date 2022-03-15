//
//  UploadPhotosMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "UploadPhotosMainView.h"

#import "HomeMainViewModel.h"

@interface UploadPhotosMainView ()
@property (nonatomic, strong) UIImageView *imgViewOne;
@property (nonatomic, strong) UIImageView *imgViewTwo;

@end

@implementation UploadPhotosMainView
#pragma mark - Event Response
- (void)onBtnWithSubmitEvent:(UIButton *)btn {
    NSString *frontImg = [(HomeMainViewModel *)self.mainViewModel frontImg];
    NSString *backImg = [(HomeMainViewModel *)self.mainViewModel backImg];
    if ([NSString isEmpty:frontImg] || [NSString isEmpty:backImg]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请填写完善身份认证信息", nil) duration:2];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithRealVerify)]) {
        [self.delegate performSelector:@selector(mainViewWithRealVerify)];
    }
}

- (void)uploadPortraitEvent {
    //上传证件带头像面照片
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithUploadPortrait)]) {
        [self.delegate performSelector:@selector(mainViewWithUploadPortrait)];
    }
}

- (void)uploadNationalEmblemEvent {
    //上传手持证件带头像照片
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithUploadNationalEmblem)]) {
        [self.delegate performSelector:@selector(mainViewWithUploadNationalEmblem)];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.imgViewOne = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"sfrz-sczp"]];
    self.imgViewOne.userInteractionEnabled = YES;
    [self.imgViewOne addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadPortraitEvent)]];
    self.imgViewOne.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imgViewOne];
    [self.imgViewOne makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(100);
    }];
    
    UILabel *lbOneTitle = [UILabel labelWithText:NSLocalizedString(@"请上传证件带头像面照片", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbOneTitle];
    [lbOneTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewOne.mas_bottom).offset(22);
        make.centerX.equalTo(0);
    }];
    
    self.imgViewTwo = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"sfrz-sczp"]];
    self.imgViewTwo.userInteractionEnabled = YES;
    [self.imgViewTwo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadNationalEmblemEvent)]];
    self.imgViewTwo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imgViewTwo];
    [self.imgViewTwo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbOneTitle.mas_bottom).offset(30);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(100);
    }];
    
    UILabel *lbTwoTitle = [UILabel labelWithText:NSLocalizedString(@"请上传本人手持证件带头像面照片", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbTwoTitle];
    [lbTwoTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewTwo.mas_bottom).offset(22);
        make.centerX.equalTo(0);
    }];
    
    UIButton *btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"提交", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSubmitEvent:)];
    btnSubmit.backgroundColor = kRGB(0, 102, 237);
    btnSubmit.layer.cornerRadius = 4;
    [self addSubview:btnSubmit];
    [btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTwoTitle.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

- (void)updateImageView {
    NSString *frontImg = [(HomeMainViewModel *)self.mainViewModel frontImg];
    NSString *backImg = [(HomeMainViewModel *)self.mainViewModel backImg];
    if (![NSString isEmpty:frontImg]) {
        [self.imgViewOne setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, frontImg]]];
    }
    if (![NSString isEmpty:backImg]) {
        [self.imgViewTwo setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, backImg]]];
    }
}

@end
