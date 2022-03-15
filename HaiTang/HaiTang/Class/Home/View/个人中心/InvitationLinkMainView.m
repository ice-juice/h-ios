//
//  InvitationLinkMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "InvitationLinkMainView.h"

#import "UserInfoManager.h"
#import "HomeMainViewModel.h"

@interface InvitationLinkMainView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imgViewQRCode;
@property (nonatomic, strong) UILabel *lbInviteCode;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *inviteLink;

@end

@implementation InvitationLinkMainView
#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.scrollView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.scrollView.contentOffset = offset;
}

#pragma mark - Event Response
- (void)onBtnWithCopyInviteCodeEvent:(UIButton *)btn {
    //复制邀请码
    UIPasteboard *myPasteboard = [UIPasteboard generalPasteboard];
    myPasteboard.string = self.inviteCode;
    [JYToastUtils showLongWithStatus:NSLocalizedString(@"复制成功", nil) completionHandle:nil];
}

- (void)onBtnWithScanEvent:(UIButton *)btn {
    //保存二维码
    UIImageWriteToSavedPhotosAlbum(self.imgViewQRCode.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [JYToastUtils showWithStatus:NSLocalizedString(@"保存成功", nil) duration:2];
    } else {
        [JYToastUtils showWithStatus:NSLocalizedString(@"保存失败", nil) duration:2];
    }
}

- (void)onBtnWithCopyInviteLinkEvent:(UIButton *)btn {
    //复制邀请链接
    UIPasteboard *myPasteboard = [UIPasteboard generalPasteboard];
    myPasteboard.string = self.inviteLink;
    [JYToastUtils showLongWithStatus:NSLocalizedString(@"复制成功", nil) completionHandle:nil];
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -kStatusBarHeight, kScreenWidth, kScreenHeight + kStatusBarHeight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 812);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 812)];
    [self.scrollView addSubview:contentView];
    
    UIImageView *imgViewBackground = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"yqlj-bg"]];
    [contentView addSubview:imgViewBackground];
    [imgViewBackground makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    UIImageView *imgViewTitle = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"yqlj-txt"]];
    [contentView addSubview:imgViewTitle];
    [imgViewTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 22);
        make.left.equalTo(34);
        make.right.equalTo(-27);
        make.height.equalTo(106);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kRGB(248, 248, 248);
    [contentView addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(338);
    }];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 12;
    [contentView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-123);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(315);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"扫描二维码获取链接地址", nil) textColor:kRGB(16, 16, 16) font:kFont(18)];
    [whiteView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.centerX.equalTo(0);
    }];
    
    self.imgViewQRCode = [[UIImageView alloc] init];
    [whiteView addSubview:self.imgViewQRCode];
    [self.imgViewQRCode makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(170);
        make.top.equalTo(lbTitle.mas_bottom).offset(15);
        make.centerX.equalTo(0);
    }];
    
    self.lbInviteCode = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
    [whiteView addSubview:self.lbInviteCode];
    [self.lbInviteCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewQRCode.mas_bottom).offset(15);
        make.left.equalTo(self.imgViewQRCode);
    }];
    
    UIButton *btnCopy = [UIButton buttonWithImageName:@"dd-fz" highlightedImageName:@"dd-fz" target:self selector:@selector(onBtnWithCopyInviteCodeEvent:)];
    [whiteView addSubview:btnCopy];
    [btnCopy makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(30);
        make.left.equalTo(self.lbInviteCode.mas_right).offset(10);
        make.centerY.equalTo(self.lbInviteCode);
    }];
    
    UIButton *btnScan = [UIButton buttonWithTitle:NSLocalizedString(@"保存二维码", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnWithScanEvent:)];
    btnScan.layer.cornerRadius = 2;
    btnScan.layer.borderColor = kRGB(0, 102, 237).CGColor;
    btnScan.layer.borderWidth = 1;
    [whiteView addSubview:btnScan];
    [btnScan makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-16);
        make.centerX.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(24);
    }];
    
    UIImageView *imgViewDian = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"yqlj-jb"]];
    [contentView addSubview:imgViewDian];
    [imgViewDian makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kStatusBarHeight);
        make.left.equalTo(0);
        make.right.equalTo(-5);
        make.height.equalTo(365);
    }];
    
    UIButton *btnCopyInviteLink = [UIButton buttonWithTitle:NSLocalizedString(@"复制邀请链接", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithCopyInviteLinkEvent:)];
    btnCopyInviteLink.backgroundColor = kRGB(0, 102, 237);
    btnCopyInviteLink.layer.cornerRadius = 4;
    [self addSubview:btnCopyInviteLink];
    [btnCopyInviteLink makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_bottom).offset(30);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

- (void)updateView {
    self.inviteCode = [UserInfoManager sharedManager].inviteCode;
    self.inviteLink = [UserInfoManager sharedManager].inviteLink;
    //链接生成二维码
    //1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.回复默认设置
    [filter setDefaults];
    //4.将链接字符串转Data格式
    NSData *stringData = [self.inviteLink dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:stringData forKey:@"inputMessage"];
    //5.生成二维码
    CIImage *qrcodeImage = [filter outputImage];
    self.imgViewQRCode.image = [qrcodeImage createNonInterpolatedWithSize:100];
    self.lbInviteCode.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"我的邀请码", nil), self.inviteCode];
}

@end
