//
//  SharePopupView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SharePopupView.h"

#import "RecordSubModel.h"

@interface SharePopupView ()
@property (nonatomic, strong) UIImageView *imgViewIncome;
@property (nonatomic, strong) UILabel *lbIncomeRate;         //收益率
@property (nonatomic, strong) UILabel *lbStatus;
@property (nonatomic, strong) UILabel *lbOpeningPrice;       //建仓价格
@property (nonatomic, strong) UIImageView *imgViewQRCode;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *downloadView;

@end

@implementation SharePopupView
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
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.downloadView = [[UIView alloc] init];
    self.downloadView.backgroundColor = [UIColor whiteColor];
    self.downloadView.layer.cornerRadius = 12;
    [self.contentView addSubview:self.downloadView];
    [self.downloadView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo((kScreenHeight - 575) / 2);
        make.left.equalTo(30);
        make.right.equalTo(-30);
        make.height.equalTo(450);
    }];
    
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = kRGB(3, 14, 30);
    [self.downloadView addSubview:blackView];
    [blackView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(350);
    }];
    
    self.imgViewIncome = [[UIImageView alloc] init];
    [self.downloadView addSubview:self.imgViewIncome];
    [self.imgViewIncome makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(28);
        make.centerX.equalTo(0);
        make.width.equalTo(115);
        make.height.equalTo(125);
    }];
    
    UILabel *lbIncomeT = [UILabel labelWithText:NSLocalizedString(@"收益率", nil) textColor:[UIColor whiteColor] font:kFont(14)];
    [self.downloadView addSubview:lbIncomeT];
    [lbIncomeT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewIncome.mas_bottom).offset(9.5);
        make.centerX.equalTo(0);
    }];
    
    self.lbIncomeRate = [UILabel labelWithText:@"-0.00%" textColor:kRGB(205, 61, 88) font:kBoldFont(30)];
    [self.downloadView addSubview:self.lbIncomeRate];
    [self.lbIncomeRate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbIncomeT.mas_bottom).offset(4);
        make.centerX.equalTo(0);
    }];
    
    self.lbStatus = [UILabel labelWithText:@"多仓BTC/USDT" textColor:kRGB(125, 145, 171) font:kFont(12)];
    [self.downloadView addSubview:self.lbStatus];
    [self.lbStatus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbIncomeRate.mas_bottom);
        make.centerX.equalTo(0);
    }];
    
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = kRGB(10, 22, 39);
    [self.downloadView addSubview:centerView];
    [centerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(275);
        make.left.right.equalTo(0);
        make.height.equalTo(75);
    }];
    
    self.lbOpeningPrice = [UILabel labelWithText:@"建仓价格\n\n00000.0" textColor:kRGB(125, 145, 171) font:kFont(14)];
    self.lbOpeningPrice.numberOfLines = 0;
    self.lbOpeningPrice.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:self.lbOpeningPrice];
    [self.lbOpeningPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
        make.width.equalTo((kScreenWidth - 60) / 2);
    }];
    self.lbOpeningPrice.attributedText = [self.lbOpeningPrice.text attributedStringWithSubString:@"00000.0" subColor:[UIColor whiteColor] subFont:kFont(18)];
    
    self.lbCurrentPrice = [UILabel labelWithText:@"当前价格\n\n00000.0" textColor:kRGB(125, 145, 171) font:kFont(14)];
    self.lbCurrentPrice.numberOfLines = 0;
    self.lbCurrentPrice.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:self.lbCurrentPrice];
    [self.lbCurrentPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(0);
        make.width.equalTo((kScreenWidth - 60) / 2);
    }];
    self.lbCurrentPrice.attributedText = [self.lbCurrentPrice.text attributedStringWithSubString:@"00000.0" subColor:[UIColor whiteColor] subFont:kFont(18)];
    
    UIImageView *imgViewLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_1"]];
    [self.downloadView addSubview:imgViewLogo];
    [imgViewLogo makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(60);
        make.left.equalTo(20);
        make.bottom.equalTo(-20);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"扫码下载App", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    lbTitle.numberOfLines = 0;
    [self.downloadView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgViewLogo.mas_right).offset(10);
        make.top.equalTo(imgViewLogo.mas_top).offset(10);
        make.right.equalTo(-100);
    }];
    
    self.imgViewQRCode = [[UIImageView alloc] init];
    [self.downloadView addSubview:self.imgViewQRCode];
    [self.imgViewQRCode makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(60);
        make.right.equalTo(-20);
        make.bottom.equalTo(-20);
    }];

    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(125);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithTitle:NSLocalizedString(@"取消", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnCancelEvent:)];
    btnCancel.layer.cornerRadius = 2;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = kRGB(0, 102, 237).CGColor;
    [bottomView addSubview:btnCancel];
    [btnCancel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(42);
        make.left.equalTo(15);
        make.width.equalTo(110);
        make.height.equalTo(34);
    }];
    
    UIButton *btnSave = [UIButton buttonWithTitle:NSLocalizedString(@"保存图片", nil) titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(255, 255, 255) font:kFont(14) target:self selector:@selector(onBtnSaveEvent:)];
    btnSave.layer.cornerRadius = 2;
    btnSave.backgroundColor = kRGB(0, 102, 237);
    [bottomView addSubview:btnSave];
    [btnSave makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.height.equalTo(34);
        make.left.equalTo(btnCancel.mas_right).offset(25);
        make.centerY.equalTo(btnCancel);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        NSString *imgName = [subModel.lossProfitRatio containsString:@"-"] ? @"fx-ks" : @"fx-yl";
        self.imgViewIncome.image = [StatusHelper imageNamed:imgName];
        
        UIColor *textColor = [subModel.lossProfitRatio containsString:@"-"] ? kRedColor : kGreenColor;
        self.lbIncomeRate.text = [NSString stringWithFormat:@"%.2f%%", [subModel.lossProfitRatio floatValue]];
        self.lbIncomeRate.textColor = textColor;
        
        NSString *status = [subModel.compactType isEqualToString:@"BUY"] ? @"多仓" : @"空仓";
        self.lbStatus.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(status, nil), subModel.symbols];
        
        self.lbOpeningPrice.text = [NSString stringWithFormat:@"%@\n%.1f", NSLocalizedString(@"建仓价格", nil), [subModel.tradePrice floatValue]];
        [self.lbOpeningPrice setParagraphSpacing:0 lineSpacing:10];
        self.lbOpeningPrice.attributedText = [self.lbOpeningPrice.text attributedStringWithSubString:[NSString stringWithFormat:@"%.1f", [subModel.tradePrice floatValue]] subColor:[UIColor whiteColor] subFont:kFont(18)];
        
        //链接生成二维码
        //1.创建滤镜对象
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        //2.回复默认设置
        [filter setDefaults];
        //4.将链接字符串转Data格式
        NSString *urlString = @"http://d.firim.top/zn17";
        NSData *stringData = [urlString dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:stringData forKey:@"inputMessage"];
        //5.生成二维码
        CIImage *qrcodeImage = [filter outputImage];
        self.imgViewQRCode.image = [qrcodeImage createNonInterpolatedWithSize:60];
        
        [self showView];
    }
}

- (void)showView {
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

#pragma mark - Event Response
- (void)onBtnCancelEvent:(UIButton *)btn {
    [self closeView];
}

- (void)onBtnSaveEvent:(UIButton *)btn {
    UIGraphicsBeginImageContextWithOptions(self.downloadView.bounds.size, 0, [[UIScreen mainScreen] scale]);
    [self.downloadView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [JYToastUtils showWithStatus:NSLocalizedString(@"保存成功", nil) duration:2];
    } else {
        [JYToastUtils showWithStatus:NSLocalizedString(@"保存失败", nil) duration:2];
    }
    [self closeView];
}

@end
