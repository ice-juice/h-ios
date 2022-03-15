//
//  QRCodeImageView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/12/8.
//  Copyright © 2020 zy. All rights reserved.
//

#import "QRCodeImageView.h"

@interface QRCodeImageView ()
@property (nonatomic, strong) UIImageView *qrCodeImage;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation QRCodeImageView
#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = .7;
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)]];
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.qrCodeImage = [[UIImageView alloc] init];
    self.qrCodeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.qrCodeImage];
    [self.qrCodeImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(kScreenWidth);
        make.centerY.equalTo(0);
        make.height.equalTo(300);
    }];
    
//    UIButton *btnClose = [UIButton buttonWithImageName:@"belvedere_ic_close" highlightedImageName:@"belvedere_ic_close" target:self selector:@selector(onBtnCloseEvent:)];
//    [self.contentView addSubview:btnClose];
//    [btnClose makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-30);
//        make.top.equalTo(kNavBarHeight);
//        make.width.height.equalTo(30);
//    }];
    
    UIButton *btnSave = [UIButton buttonWithTitle:NSLocalizedString(@"保存", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnSaveEvent:)];
    btnSave.backgroundColor = kRGB(0, 102, 237);
    btnSave.layer.cornerRadius = 5;
    [self.contentView addSubview:btnSave];
    [btnSave makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeImage.mas_bottom).offset(30);
        make.right.equalTo(-30);
        make.width.equalTo(80);
        make.height.equalTo(30);
    }];
}

- (void)showView:(NSString *)imgUrl {
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, imgUrl];
    [self.qrCodeImage setImageURL:[NSURL URLWithString:imageUrl]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}

#pragma mark - Event Response
- (void)onBtnCloseEvent:(UIButton *)btn {
    [self closeView];
}

- (void)onBtnSaveEvent:(UIButton *)btn {
    //保存图片
    UIImageWriteToSavedPhotosAlbum(self.qrCodeImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [JYToastUtils showWithStatus:NSLocalizedString(@"保存成功", nil) duration:2];
    } else {
        [JYToastUtils showWithStatus:NSLocalizedString(@"保存失败", nil) duration:2];
    }
    [self closeView];
}

@end
