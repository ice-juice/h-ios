//
//  BaseTableViewController.h
//  iShop
//
//  Created by JY on 2018/6/7.
//  Copyright © 2018年 帝辰科技. All rights reserved.
//  

#import "BaseViewController.h"

static CGFloat const kZeroHeight = 0.00001f;

@interface BaseTableViewController : BaseViewController

@property (nonatomic, strong) UITableView *tableView;
/** 默认每页条数 */
@property (nonatomic, assign) NSInteger pageSize;
/** 当前页码, 从1开始 */
@property (nonatomic, assign) NSInteger pageNo;
/** 当前刷新状态 */
@property (nonatomic, assign) NSInteger currentRefreshStatus;

/**
 *  设置UITableView
 *  @param delegate UITableView的代理
 *  @return 返回一个UITableView
 */
- (UITableView *)setupTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate;

- (UITableView *)setupTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate style:(UITableViewStyle)style;

- (UITableView *)setupTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate  shouldRefresh:(BOOL)shouldRefresh;

- (UITableView *)setupTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate style:(UITableViewStyle)style shouldRefresh:(BOOL)shouldRefresh;

/**
 给View设置UITableView
 @param superView 需要添加到的View
 @param frame tableView的frame
 @param delegate 代理对象
 @param style  tableView的样式
 @return UITableView
 */
- (UITableView *)setupTableViewForView:(UIView *)superView frame:(CGRect)frame delegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate style:(UITableViewStyle)style;

- (UITableView *)setupTableViewForView:(UIView *)superView frame:(CGRect)frame delegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate style:(UITableViewStyle)style shouldRefresh:(BOOL)shouldRefresh;

/** 下拉处理 */
- (void)pullDownHandle;

/** 上拉处理 */
- (void)pullUpHandle;

/** 停止刷新头部 */
- (void)endRefreshingHeader;

/** 停止刷新尾部 */
- (void)endRefreshingFooter;

/** 是否显示头部控件 */
- (void)showHeaderView:(BOOL)show;

/** 是否显示尾部控件 */
- (void)showFooterView:(BOOL)show;

@end
