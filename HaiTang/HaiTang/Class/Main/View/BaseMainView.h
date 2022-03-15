//
//  BaseMainView.h
//  BlueLeaf
//
//  Created by XQ on 2018/12/17.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class BaseMainViewModel;

@protocol BaseMainViewDelegate <NSObject>

/**
 基类的代理方法
 */

@optional

/** 上拉加载 */
- (void)pullUpHandleOfContentView:(UIView *)contentView;

/** 下拉刷新 */
- (void)pullDownHandleOfContentView:(UIView *)contentView;

@end

@class EmptyView;

@interface BaseMainView : BaseView

@property (nonatomic, strong) BaseMainViewModel *mainViewModel;

/** mainView的代理 */
@property (nonatomic, weak) id<BaseMainViewDelegate> delegate;

/** 当前刷新状态 */
@property (nonatomic, assign) RefreshStatus currentRefreshStatus;

/** 上拉加载的文字颜色 */
@property (nonatomic, strong) UIColor *pullUpTextColor;

/** 下拉刷新的文字颜色 */
@property (nonatomic, strong) UIColor *pullDownTextColor;

/** 上拉加载的加载动画颜色 */
@property (nonatomic, assign) UIActivityIndicatorViewStyle pullUpViewStyle;

/** 下拉刷新的加载动画颜色 */
@property (nonatomic, assign) UIActivityIndicatorViewStyle pullDownViewStyle;

/** 数据为空的时候显示的view */
@property (nonatomic, strong) EmptyView *emptyView;

- (instancetype)initWithDelegate:(id<BaseMainViewDelegate>)delegate;

- (instancetype)initWithDelegate:(nullable id<BaseMainViewDelegate>)delegate viewModel:(nullable BaseMainViewModel *)viewModel;

- (instancetype)initWithViewModel:(BaseMainViewModel *)viewModel;

/** 请求到数据后刷新UI */
- (void)updateView;

/** 是否显示头部刷新控件 */
- (void)showHeaderView:(BOOL)show;

/** 是否显示尾部刷新控件 */
- (void)showFooterView:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
