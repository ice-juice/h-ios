//
//  BaseTableView.m
//  BlueLeaf
//
//  Created by XQ on 2018/12/19.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import "BaseTableView.h"
#import "BaseMainViewModel.h"

@implementation BaseTableView
#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kkZeroHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kkZeroHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
}

#pragma mark - Super Class
- (void)setupSubViews {
    
}

#pragma mark - Event Response
// 下拉刷新回调
- (void)pullDownToRefresh {
    self.mainViewModel.currentRefreshStatus = RefreshStatusPullDown;
    
    self.currentRefreshStatus = RefreshStatusPullDown;
    [self endRefreshingHeader];
    [self pullDownHandle];
}

- (void)pullDownHandle {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pullDownHandleOfContentView:)]) {
        [self.delegate pullDownHandleOfContentView:self.tableView];
    }
}

// 上拉加载更多回调
- (void)pullUpToRefresh {
    self.mainViewModel.currentRefreshStatus = RefreshStatusPullUp;
    self.currentRefreshStatus = RefreshStatusPullUp;
    [self endRefreshingFooter];
    [self pullUpHandle];
}

- (void)pullUpHandle {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pullUpHandleOfContentView:)]) {
        [self.delegate pullUpHandleOfContentView:self.tableView];
    }
}

// 结束刷新
- (void)endRefreshingHeader {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)endRefreshingFooter {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}

// 是否显示头部刷新控件
- (void)showHeaderView:(BOOL)show {
    self.tableView.mj_header.hidden = !show;
}

// 是否显示尾部刷新控件
- (void)showFooterView:(BOOL)show {
    self.tableView.mj_footer.hidden = !show;
}

#pragma mark 如果需要添加UITableView直接调用一下方法即可
- (UITableView *)setupTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate {
    return [self setupTableViewWithDelegate:delegate style:UITableViewStylePlain shouldRefresh:NO];
}

- (UITableView *)setupTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate style:(UITableViewStyle)style {
    return [self setupTableViewWithDelegate:delegate style:style shouldRefresh:NO];
}

- (UITableView *)setupTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate shouldRefresh:(BOOL)shouldRefresh {
    return [self setupTableViewWithDelegate:delegate style:UITableViewStylePlain shouldRefresh:shouldRefresh];
}

- (UITableView *)setupTableViewWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate style:(UITableViewStyle)style shouldRefresh:(BOOL)shouldRefresh {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:style];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = kSeparateLineColor;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.hidden = YES;
    [self addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
            
        } else {
            make.edges.equalTo(self);
        }
    }];
    
    if (shouldRefresh) {
        [self sutupRefreshComponent:tableView];
    }
    
    return tableView;
}

- (void)sutupRefreshComponent:(UITableView *)tableView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉刷新", nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"松开刷新", nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"加载中...", nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = self.pullDownTextColor;
//    header.activityIndicatorViewStyle = self.pullDownViewStyle;
    tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToRefresh)];
    [footer setTitle:NSLocalizedString(@"加载完成", nil) forState:MJRefreshStateIdle];
    [footer setTitle:NSLocalizedString(@"加载中...", nil) forState:MJRefreshStateRefreshing];
    [footer setTitle:NSLocalizedString(@"没有更多的数据了", nil) forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = self.pullUpTextColor;
    footer.activityIndicatorViewStyle = self.pullUpViewStyle;
    tableView.mj_footer = footer;
    tableView.mj_footer.hidden = YES;
}

@end
