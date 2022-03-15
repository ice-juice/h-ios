//
//  CustomNavBar.m
//  MeiYi
//
//  Created by XQ on 2019/1/22.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import "CustomNavBar.h"

@interface CustomNavBar ()
@property (nonatomic, strong) UIImageView *imageViewBackground;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *buttonReturn;
@property (nonatomic, strong) UIView *separateView;
@end

@implementation CustomNavBar
#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDatas];
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatas];
        [self setupSubViews];
    }
    return self;
}
#pragma mark - Event Response
- (void)onBtnReturnEvent:(UIButton *)btn {
    if (self.onReturnBlock) {
        self.onReturnBlock();
    }
}
#pragma mark - Private Method
- (void)initDatas {
    _titleColor = kRGB(16, 16, 16);
    _titleFont = kFont(18);
    _navBackgroundColor = [UIColor whiteColor];
    _returnType = NavReturnTypeBlack;
    _separateColor = kSeparateLineColor;
    _separateHeight = 0.5;
    _hiddenReturn = NO;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    self.imageViewBackground = [[UIImageView alloc] init];
    self.imageViewBackground.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageViewBackground];
    [self.imageViewBackground makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.labelTitle = [UILabel labelWithText:@"" textColor:self.titleColor font:self.titleFont];
    [self addSubview:self.labelTitle];
    [self.labelTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
//        make.centerY.equalTo(0);
        make.height.equalTo(44);
        make.bottom.equalTo(0);
    }];
    self.buttonReturn = [UIButton buttonWithImageName:@"return_black" highlightedImageName:@"return_black" target:self selector:@selector(onBtnReturnEvent:)];
    [self addSubview:self.buttonReturn];
    self.buttonReturn.contentMode = UIViewContentModeScaleAspectFit;
    [self.buttonReturn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
//        make.centerY.equalTo(0);
        make.bottom.equalTo(0);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
    self.separateView = [[UIView alloc] init];
    self.separateView.backgroundColor = self.separateColor;
    [self addSubview:self.separateView];
    [self.separateView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(self.separateHeight);
    }];
}
#pragma mark - Setter And Getter
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.labelTitle.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.labelTitle.font = titleFont;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.labelTitle.text = title;
}

- (void)setNavBackgroundColor:(UIColor *)navBackgroundColor {
    [self.imageViewBackground setImage:nil];
    _navBackgroundColor = navBackgroundColor;
    self.backgroundColor = navBackgroundColor;
}

- (void)setNavBackgroundImage:(UIImage *)navBackgroundImage {
    _navBackgroundImage = navBackgroundImage;
    [self.imageViewBackground setImage:navBackgroundImage];
}

- (void)setReturnType:(NavReturnType)returnType {
    _returnType = returnType;
    if (returnType == NavReturnTypeBlack) {
        [self.buttonReturn setImage:[UIImage imageNamed:@"return_black"] forState:UIControlStateNormal];
    } else {
        [self.buttonReturn setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    }
}

- (void)setTitleView:(UIView *)titleView {
    if (_titleView) {
        [_titleView removeFromSuperview];
        _titleView = nil;
    }
    _titleView = titleView;
    [self addSubview:titleView];
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(40);
        make.left.equalTo(100);
        make.right.equalTo(-100);
    }];
}

- (void)setSeparateColor:(UIColor *)separateColor {
    _separateColor = separateColor;
    self.separateView.backgroundColor = separateColor;
}

- (void)setSeparateHeight:(CGFloat)separateHeight {
    _separateHeight = separateHeight;
    [self.separateView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(separateHeight);
    }];
}

- (void)setHiddenReturn:(BOOL)hiddenReturn {
    _hiddenReturn = hiddenReturn;
    self.buttonReturn.hidden = hiddenReturn;
}

- (void)setHiddenSeparateLine:(BOOL)hiddenSeparateLine {
    _hiddenSeparateLine = hiddenSeparateLine;
    self.separateView.hidden = hiddenSeparateLine;
}

- (void)setNavRightView:(UIView *)navRightView {
    if (_navRightView) {
        [_navRightView removeFromSuperview];
        _navRightView = nil;
    }
    _navRightView = navRightView;
    [self addSubview:navRightView];
    [navRightView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(40);
    }];
}

- (void)setNavLeftView:(UIView *)navLeftView {
    if (_navLeftView) {
        [_navLeftView removeFromSuperview];
        _navLeftView = nil;
    }
    _navLeftView = navLeftView;
    [self addSubview:navLeftView];
    [navLeftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(self);
        make.height.equalTo(40);
    }];
}

- (void)setNavSubLeftView:(UIView *)navSubLeftView {
    if (_navSubLeftView) {
        [_navSubLeftView removeFromSuperview];
        _navSubLeftView = nil;
    }
    _navSubLeftView = navSubLeftView;
    [self addSubview:navSubLeftView];
    [navSubLeftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.bottom.equalTo(self);
        make.height.equalTo(40);
    }];
}

@end
