//
//  BaseMainView.m
//  BlueLeaf
//
//  Created by XQ on 2018/12/17.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import "BaseMainView.h"

@implementation BaseMainView
#pragma mark - Life Cycle
- (instancetype)initWithDelegate:(id<BaseMainViewDelegate>)delegate {
    return [self initWithDelegate:delegate viewModel:nil];
}

- (instancetype)initWithViewModel:(BaseMainViewModel *)viewModel {
    return [self initWithDelegate:nil viewModel:viewModel];
}

- (instancetype)initWithDelegate:(id<BaseMainViewDelegate>)delegate viewModel:(BaseMainViewModel *)viewModel {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _mainViewModel = viewModel;
    }
    
    return self;
}

- (void)setupSubViews {
    // 子类重写，绘制mainView
}

#pragma mark - External Interface

- (void)updateView {
    // 子类重写，请求完数据后刷新mainView
}

- (void)showHeaderView:(BOOL)show {
    // 子类重写，是否显示头部刷新控件
}

- (void)showFooterView:(BOOL)show {
    // 子类重写，是否显示尾部刷新控件
}


#pragma mark - Setter & Getter
- (UIColor *)pullDownTextColor {
    if (!_pullDownTextColor) {
        _pullDownTextColor = [UIColor grayColor];
    }
    
    return _pullDownTextColor;
}

- (UIActivityIndicatorViewStyle)pullDownViewStyle {
    if (!_pullDownViewStyle) {
        _pullDownViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    return _pullDownViewStyle;
}

- (UIColor *)pullUpTextColor {
    if (!_pullUpTextColor) {
        _pullUpTextColor = [UIColor grayColor];
    }
    
    return _pullUpTextColor;
}

- (UIActivityIndicatorViewStyle)pullUpViewStyle {
    if (!_pullUpViewStyle) {
        _pullUpViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    return _pullUpViewStyle;
}

@end
