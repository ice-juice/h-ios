//
//  BaseCollectionView.m
//  BlueLeaf
//
//  Created by XQ on 2018/12/21.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import "BaseCollectionView.h"
#import "BaseMainViewModel.h"

@implementation BaseCollectionView
#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(0, 0);
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didSelectedIndex:)]) {
        [self.delegate performSelector:@selector(collectionView:didSelectedIndex:) withObject:collectionView withObject:indexPath];
    }
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
        [self.delegate pullDownHandleOfContentView:self.collectionView];
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
        [self.delegate pullUpHandleOfContentView:self.collectionView];
    }
}

// 结束刷新
- (void)endRefreshingHeader {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)endRefreshingFooter {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_footer endRefreshing];
    });
}

// 是否显示头部刷新控件
- (void)showHeaderView:(BOOL)show {
    self.collectionView.mj_header.hidden = !show;
}

// 是否显示尾部刷新控件
- (void)showFooterView:(BOOL)show {
    self.collectionView.mj_footer.hidden = !show;
}

// 开始刷新
- (void)beginRefresh {
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark -
- (UICollectionView *)setupCollectionViewWithDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>)delegate lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing {
    return [self setupCollectionViewWithDelegate:delegate lineSpacing:lineSpacing interitemSpacing:interitemSpacing sectionInset:UIEdgeInsetsMake(0, 0, 0, 0) shouldRefresh:NO];
}

- (UICollectionView *)setupCollectionViewWithDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>)delegate lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing shouldRefresh:(BOOL)shouldRefresh {
    return [self setupCollectionViewWithDelegate:delegate lineSpacing:lineSpacing interitemSpacing:interitemSpacing sectionInset:UIEdgeInsetsMake(0, 0, 0, 0) shouldRefresh:shouldRefresh];
}

- (UICollectionView *)setupCollectionViewWithDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>)delegate lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing sectionInset:(UIEdgeInsets)sectionInset {
    return [self setupCollectionViewWithDelegate:delegate lineSpacing:lineSpacing interitemSpacing:interitemSpacing sectionInset:sectionInset shouldRefresh:NO];
}

- (UICollectionView *)setupCollectionViewWithDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>)delegate lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing sectionInset:(UIEdgeInsets)sectionInset shouldRefresh:(BOOL)shouldRefresh {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = interitemSpacing; //左右间距
    flowLayout.minimumLineSpacing = lineSpacing;    // 上下间距
    flowLayout.sectionInset = sectionInset;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = delegate;
    collectionView.dataSource = delegate;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.hidden = YES;
    [self addSubview:collectionView];
    [collectionView makeConstraints:^(MASConstraintMaker *make) {
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
        [self sutupRefreshComponent:collectionView];
    }
    
    return collectionView;
}

- (void)sutupRefreshComponent:(UICollectionView *)collectionView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉刷新", nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"松开刷新", nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"加载中...", nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = self.pullDownTextColor;
    header.activityIndicatorViewStyle = self.pullDownViewStyle;
    collectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToRefresh)];
    [footer setTitle:NSLocalizedString(@"加载完成", nil) forState:MJRefreshStateIdle];
    [footer setTitle:NSLocalizedString(@"加载中...", nil) forState:MJRefreshStateRefreshing];
    [footer setTitle:NSLocalizedString(@"没有更多的数据了", nil) forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = self.pullUpTextColor;
    footer.activityIndicatorViewStyle = self.pullUpViewStyle;
    collectionView.mj_footer = footer;
    collectionView.mj_footer.hidden = YES;
}


@end
