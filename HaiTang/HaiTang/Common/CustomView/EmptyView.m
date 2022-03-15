//
//  EmptyView.m
//  iShop
//
//  Created by XQ on 2018/6/14.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import "EmptyView.h"
#import "StatusHelper.h"
@interface EmptyView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGSize imageSize;
@end
@implementation EmptyView

- (instancetype)initWithSuperView:(UIView *)superView title:(NSString *)title imageName:(NSString *)imageName {
    return [self initWithSuperView:superView title:title imageName:imageName titleColor:kRGB(204, 204, 204) imageSize:CGSizeMake(98, 98)];
}

- (instancetype)initWithSuperView:(UIView *)superView title:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor {
    return [self initWithSuperView:superView title:title imageName:imageName titleColor:titleColor imageSize:CGSizeMake(98, 98)];
}

- (instancetype)initWithSuperView:(UIView *)superView title:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor imageSize:(CGSize)imageSize {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 250) superView:superView title:title imageName:imageName titleColor:titleColor imageSize:imageSize];
}

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView title:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor imageSize:(CGSize)imageSize {
    self = [super init];
    if (self) {
        [superView addSubview:self];
        _title = title;
        _imageName = imageName;
        _imageSize = imageSize;
        _titleColor = titleColor;
        self.frame = frame;
        self.center = CGPointMake(kScreenWidth / 2, (kScreenHeight - 300) / 2);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:_imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.equalTo(self.imageSize.width);
        make.height.equalTo(self.imageSize.height);
        make.centerX.equalTo(self);
    }];
    _titleLabel = [UILabel labelWithText:_title textAlignment:NSTextAlignmentCenter textColor:_titleColor font:kFont(15) numberOfLines:0];
    [self addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenWidth);
        make.top.equalTo(imageView.mas_bottom).offset(20);
    }];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleLabel.textColor = titleColor;
}

@end
