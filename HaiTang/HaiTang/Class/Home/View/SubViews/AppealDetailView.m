//
//  AppealDetailView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AppealDetailView.h"

#import "OrderModel.h"

@interface AppealDetailView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *lbContent;
@property (nonatomic, strong) UIImageView *imgView0;
@property (nonatomic, strong) UIImageView *imgView1;
@property (nonatomic, strong) UIImageView *imgView2;

@end

@implementation AppealDetailView
#pragma mark - Event Response
- (void)onBtnWithSureEvent:(UIButton *)btn {
    [self closeView];
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = .1;
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
        make.height.equalTo(295);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"申诉详情", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(18)];
    [self.contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.centerX.equalTo(0);
    }];
    
    self.lbContent = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
    self.lbContent.numberOfLines = 0;
    [self.contentView addSubview:self.lbContent];
    [self.lbContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(20);
        make.left.equalTo(20);
        make.right.equalTo(-20);
    }];
    
    CGFloat lineSpace = (kScreenWidth - 300) / 4;
    self.imgView0 = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgView0];
    [self.imgView0 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineSpace);
        make.top.equalTo(self.lbContent.mas_bottom).offset(15);
        make.width.height.equalTo(100);
    }];
    
    self.imgView1 = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgView1];
    [self.imgView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView0.mas_right).offset(lineSpace);
        make.centerY.equalTo(self.imgView1);
        make.width.height.equalTo(100);
    }];
    
    self.imgView2 = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgView2];
    [self.imgView2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-lineSpace);
        make.centerY.equalTo(self.imgView1);
        make.width.height.equalTo(100);
    }];
    
    UIButton *btnSure = [UIButton buttonWithTitle:NSLocalizedString(@"知道了", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSureEvent:)];
    btnSure.backgroundColor = kRGB(0, 102, 237);
    btnSure.layer.cornerRadius = 2;
    [self.contentView addSubview:btnSure];
    [btnSure makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-21);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(34);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[OrderModel class]]) {
        OrderModel *orderModel = model;
        
        NSString *content = @"";
        NSString *img = @"";
        if ([orderModel.pageType isEqualToString:@"BUY"]) {
            //购买订单
            if ([self.type isEqualToString:@"0"]) {
                //查看买家
                content = orderModel.content;
                img = orderModel.img;
            } else {
                //查看卖家
                content = orderModel.content1;
                img = orderModel.img1;
            }
        } else {
            //出售订单
            if ([self.type isEqualToString:@"0"]) {
                //查看卖家
                content = orderModel.content1;
                img = orderModel.img1;
            } else {
                //查看买家
                content = orderModel.content;
                img = orderModel.img;
            }
        }
        
        self.lbContent.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"申诉理由", nil), content];
        NSArray *imgArray = [img componentsSeparatedByString:@","];
        if (imgArray && [imgArray count]) {
            [imgArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    [self.imgView0 setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, obj]]];
                }
                if (idx == 1) {
                    [self.imgView1 setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, obj]]];
                }
                if (idx == 2) {
                    [self.imgView2 setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, obj]]];
                }
            }];
        }
        [self showView];
    }
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, 0, kScreenWidth, 295)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, (kScreenHeight - 295) / 2, kScreenWidth, 295)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}

@end
