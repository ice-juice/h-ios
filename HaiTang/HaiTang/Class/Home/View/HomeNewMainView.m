//
//  HomeNewMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2021/2/2.
//  Copyright © 2021 zy. All rights reserved.
//

#import "HomeNewMainView.h"
#import "NewPagedFlowView.h"
#import "HomeMarketView.h"

#import "HomeTableHeaderCollectionCell.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

#import "NewModel.h"
#import "QuotesModel.h"
#import "BannerModel.h"
#import "HomeTableModel.h"
#import "HomeMainViewModel.h"

@interface HomeNewMainView ()
<
SDCycleScrollViewDelegate,
NewPagedFlowViewDelegate,
NewPagedFlowViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate
>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NewPagedFlowView *bannerCycleView;
@property (nonatomic, strong) SDCycleScrollView *textCycleView;
@property (nonatomic, strong) UIView *collectionBtnView;
@property (nonatomic, strong) UIView *noticeView;
@property (nonatomic, strong) HomeMarketView *marketView;

@property (nonatomic, strong) NSArray<BannerModel *> *arrayBannerDatas;

@end

@implementation HomeNewMainView
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat srcImageViewHeight = kScreenWidth * 350 / 750 + kStatusBarHeight - 20;
//    CGPoint offset = scrollView.contentOffset;
//    
//    CGRect rect = self.topMainView.frame;
//    //我们只需要改变图片的y值和高度即可
//    if (offset.y > (srcImageViewHeight - kNavBarHeight)) {
//        offset.y = srcImageViewHeight - kNavBarHeight;
//    }
//    rect.size.height = srcImageViewHeight - offset.y;
//    self.topMainView.frame = rect;
//    
//    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
//    //获取拖动的距离
//    CGFloat velocity = [pan velocityInView:scrollView].y;
//    if (velocity < 0) {
//        //小于0，禁止向上拖动
//        //设置为NO,窗口不会显示contentSize范围外的内容
//        scrollView.bounces = NO;
//    } else {
//        scrollView.bounces = YES;
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithScrollView:)]) {
        [self.delegate performSelector:@selector(viewWithScrollView:) withObject:scrollView];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([(HomeMainViewModel *)self.mainViewModel arrayContractPrices]) {
        return [[(HomeMainViewModel *)self.mainViewModel arrayContractPrices] count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableHeaderCollectionCell *cell = [HomeTableHeaderCollectionCell cellWithNibCollectionView:collectionView withIndexPath:indexPath];
    if (indexPath.item < [[(HomeMainViewModel *)self.mainViewModel arrayContractPrices] count]) {
        QuotesModel *quotesModel = [(HomeMainViewModel *)self.mainViewModel arrayContractPrices][indexPath.item];
        [cell setViewWithModel:quotesModel];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth / 3, 120);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item < [[(HomeMainViewModel *)self.mainViewModel arrayContractPrices] count]) {
        QuotesModel *quotesModel = [(HomeMainViewModel *)self.mainViewModel arrayContractPrices][indexPath.item];
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithCheckKline:)]) {
            [self.delegate performSelector:@selector(viewWithCheckKline:) withObject:quotesModel.symbol];
        }
    }
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithCheckNoticeDetail:)]) {
        [self.delegate performSelector:@selector(viewWithCheckNoticeDetail:) withObject:[NSString stringWithFormat:@"%ld", index]];
    }
}
#pragma mark - NewPagedFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    //当前cell大小
    return  CGSizeMake(kScreenWidth - 30, 150);
}

- (void)didSelectCell:(PGIndexBannerSubiew *)subView withSubViewIndex:(NSInteger)subIndex {
    //点击了哪张图
    if (subIndex < self.arrayBannerDatas.count) {
        BannerModel *model = self.arrayBannerDatas[subIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithSelectBanner:)]) {
            [self.delegate performSelector:@selector(viewWithSelectBanner:) withObject:model.link];
        }
    }
}
#pragma mark - NewPagedFlowViewDataSource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return [self.arrayBannerDatas count];
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    if (index < [self.arrayBannerDatas count]) {
        BannerModel *bannerModel = self.arrayBannerDatas[index];
        bannerView.mainImageView.imageURL = [NSURL URLWithString:bannerModel.img];
    }
    return bannerView;
}
#pragma mark - Event Response
- (void)onBtnWithRechargeEvent:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithCheckRecharge)]) {
        [self.delegate performSelector:@selector(viewWithCheckRecharge)];
    }
}

- (void)onBtnWithFiatEvent:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithCheckFiat)]) {
        [self.delegate performSelector:@selector(viewWithCheckFiat)];
    }
}

- (void)onBtnWithWithdrawEvent:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithCheckWithdraw)]) {
        [self.delegate performSelector:@selector(viewWithCheckWithdraw)];
    }
}

- (void)onBtnWithInviteFriendsEvent:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithCheckInviteFriend)]) {
        [self.delegate performSelector:@selector(viewWithCheckInviteFriend)];
    }
}

- (void)onCheckPlatformNotice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithCheckNotice)]) {
        [self.delegate performSelector:@selector(viewWithCheckNotice)];
    }
}

- (void)onCheckHelpCenter {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithCheckHelpCenter)]) {
        [self.delegate performSelector:@selector(viewWithCheckHelpCenter)];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -kStatusBarHeight, kScreenWidth, kScreenHeight)];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 800);
    self.mainScrollView.delegate = self;
    //设置为NO,窗口不会显示contentSize范围外的内容
    self.mainScrollView.bounces = NO;
    [self addSubview:self.mainScrollView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 800)];
    [self.mainScrollView addSubview:self.contentView];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:headerView];
    [headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.width.equalTo(self);
        make.height.equalTo(405.5);
    }];
    
    UIImageView *topMainView = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"sy_bg"]];
    [headerView addSubview:topMainView];
    [topMainView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(212);
    }];
    
    self.bannerCycleView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, 170)];
    self.bannerCycleView.delegate = self;
    self.bannerCycleView.dataSource = self;
    self.bannerCycleView.minimumPageAlpha = 0.1;
    self.bannerCycleView.isCarousel = YES;
    self.bannerCycleView.orientation = NewPagedFlowViewOrientationHorizontal;
    self.bannerCycleView.isOpenAutoScroll = YES;
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 164, kScreenWidth, 4)];
    pageControl.pageIndicatorTintColor = kRGB(193, 193, 193);
    pageControl.currentPageIndicatorTintColor = kRGB(15, 140, 246);
    self.bannerCycleView.pageControl = pageControl;
    [self.bannerCycleView addSubview:pageControl];
    [self.bannerCycleView reloadData];
    [headerView addSubview:self.bannerCycleView];
    
    UIImageView *imgViewNotice = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"tz"]];
    [headerView addSubview:imgViewNotice];
    [imgViewNotice makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(14);
        make.height.equalTo(16);
        make.left.equalTo(15);
        make.top.equalTo(self.bannerCycleView.mas_bottom).offset(15);
    }];
    
    [headerView addSubview:self.textCycleView];
    [self.textCycleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgViewNotice.mas_right).offset(0);
        make.height.equalTo(30);
        make.width.equalTo(kScreenWidth - 64);
        make.centerY.equalTo(imgViewNotice);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [headerView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textCycleView.mas_bottom).offset(4);
        make.left.equalTo(15);
        make.width.equalTo(kScreenWidth - 30);
        make.height.equalTo(0.5);
    }];
    
    [headerView addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(0);
        make.width.equalTo(self);
        make.height.equalTo(120);
    }];
    
    [self.contentView addSubview:self.collectionBtnView];
    [self.collectionBtnView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(15);
        make.left.equalTo(0);
        make.width.equalTo(self);
        make.height.equalTo(82);
    }];
    
    [self.contentView addSubview:self.noticeView];
    [self.noticeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionBtnView.mas_bottom).offset(15);
        make.left.equalTo(0);
        make.width.equalTo(self);
        make.height.equalTo(60);
    }];
    
    [self.contentView addSubview:self.marketView];
    [self.marketView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noticeView.mas_bottom).offset(15);
        make.left.equalTo(0);
        make.width.equalTo(self);
        make.height.equalTo(85);
    }];
}

- (void)updateView {
    CGFloat scrollViewHeight = [(HomeMainViewModel *)self.mainViewModel scrollViewHeight];
    CGFloat quotesHeight = [(HomeMainViewModel *)self.mainViewModel homeQuotesHeight];
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, scrollViewHeight);
    self.contentView.height = scrollViewHeight;
    [self.marketView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(quotesHeight);
    }];
    [self.marketView setViewWithModel:[(HomeMainViewModel *)self.mainViewModel arrayQuotesDatas]];
}

- (void)updateContractView {
    [self.collectionView reloadData];
}

- (void)updateHeaderView {
    self.arrayBannerDatas = [(HomeMainViewModel *)self.mainViewModel arrayBannerDatas];
    [self.bannerCycleView reloadData];
    
    NSMutableArray *arrayTitle = [NSMutableArray arrayWithCapacity:10];
    [[(HomeMainViewModel *)self.mainViewModel arrayNewDatas] enumerateObjectsUsingBlock:^(NewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayTitle addObject:obj.title];
    }];
    self.textCycleView.titlesGroup = arrayTitle;
}

#pragma mark - Setter & Getter
- (SDCycleScrollView *)textCycleView {
    if (!_textCycleView) {
        _textCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _textCycleView.backgroundColor = [UIColor clearColor];
        _textCycleView.autoScrollTimeInterval = autoScrollTimeInterval;
        _textCycleView.showPageControl = NO;
        _textCycleView.onlyDisplayText = YES;
        _textCycleView.titleLabelTextFont = kBoldFont(12);
        _textCycleView.titleLabelTextColor = kRGB(16, 16, 16);
        _textCycleView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _textCycleView.titleLabelBackgroundColor = [UIColor clearColor];
    }
    return _textCycleView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeTableHeaderCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([HomeTableHeaderCollectionCell class])];
    }
    return _collectionView;
}

- (UIView *)collectionBtnView {
    if (!_collectionBtnView) {
        _collectionBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 82)];
        _collectionBtnView.backgroundColor = [UIColor whiteColor];
        
        UIButton *btnFiat = [UIButton buttonWithTitle:NSLocalizedString(@"法币", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithFiatEvent:)];
        [btnFiat setImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];
        [_collectionBtnView addSubview:btnFiat];
        [btnFiat makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(0);
            make.width.equalTo(self.collectionBtnView.mas_width).multipliedBy(0.25);
            make.height.equalTo(82);
        }];
        [btnFiat setTitleDownSpace:10];
        
        UIButton *btnRecharge = [UIButton buttonWithTitle:NSLocalizedString(@"充币", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithRechargeEvent:)];
        [btnRecharge setImage:[UIImage imageNamed:@"cb"] forState:UIControlStateNormal];
        [_collectionBtnView addSubview:btnRecharge];
        [btnRecharge makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(btnFiat);
            make.left.equalTo(btnFiat.mas_right);
        }];
        [btnRecharge setTitleDownSpace:10];
        
        UIButton *btnWithdraw = [UIButton buttonWithTitle:NSLocalizedString(@"提币", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithWithdrawEvent:)];
        [btnWithdraw setImage:[UIImage imageNamed:@"tb"] forState:UIControlStateNormal];
        [_collectionBtnView addSubview:btnWithdraw];
        [btnWithdraw makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(btnRecharge);
            make.left.equalTo(btnRecharge.mas_right);
        }];
        [btnWithdraw setTitleDownSpace:10];
        
        UIButton *btnInvite = [UIButton buttonWithTitle:NSLocalizedString(@"邀请好友", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithInviteFriendsEvent:)];
        [btnInvite setImage:[UIImage imageNamed:@"yqhy"] forState:UIControlStateNormal];
        [_collectionBtnView addSubview:btnInvite];
        [btnInvite makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(btnWithdraw);
            make.right.equalTo(0);
        }];
        [btnInvite setTitleDownSpace:10];
    }
    return _collectionBtnView;
}

- (UIView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        
        UIView *announView = [[UIView alloc] init];
        announView.backgroundColor = [UIColor whiteColor];
        announView.layer.cornerRadius = 4;
        announView.userInteractionEnabled = YES;
        [announView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCheckPlatformNotice)]];
        [_noticeView addSubview:announView];
        [announView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(0);
            make.width.equalTo(self.noticeView).multipliedBy(0.49);
            make.height.equalTo(60);
        }];
        
        UIImageView *platImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ptgg"]];
        [announView addSubview:platImgView];
        [platImgView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-9);
            make.top.equalTo(8);
            make.width.equalTo(52);
            make.height.equalTo(50);
        }];
        
        UILabel *lbTitle0 = [UILabel labelWithText:@"平台公告" textColor:kRGB(16, 16, 16) font:kBoldFont(12)];
        [announView addSubview:lbTitle0];
        [lbTitle0 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(12);
            make.left.equalTo(30);
        }];
        
        UILabel *lbSubTitle0 = [UILabel labelWithText:@"Platform Notice" textColor:kRGB(153, 153, 153) font:kFont(9)];
        [announView addSubview:lbSubTitle0];
        [lbSubTitle0 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbTitle0);
            make.bottom.equalTo(-12);
        }];
        
        UIView *helpView = [[UIView alloc] init];
        helpView.backgroundColor = [UIColor whiteColor];
        helpView.layer.cornerRadius = 4;
        helpView.userInteractionEnabled = YES;
        [helpView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCheckHelpCenter)]];
        [_noticeView addSubview:helpView];
        [helpView makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(0);
            make.width.height.equalTo(announView);
        }];
        
        UIImageView *helpImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bzzx"]];
        [helpView addSubview:helpImgView];
        [helpImgView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-24.5);
            make.top.equalTo(7);
            make.width.equalTo(47);
            make.height.equalTo(47);
        }];
        
        UILabel *lbTitle1 = [UILabel labelWithText:@"帮助中心" textColor:kRGB(16, 16, 16) font:kBoldFont(12)];
        [helpView addSubview:lbTitle1];
        [lbTitle1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(12);
            make.left.equalTo(15);
        }];
        
        UILabel *lbSubTitle1 = [UILabel labelWithText:@"Help Center" textColor:kRGB(153, 153, 153) font:kFont(9)];
        [helpView addSubview:lbSubTitle1];
        [lbSubTitle1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbTitle1);
            make.bottom.equalTo(-12);
        }];
    }
    return _noticeView;
}

- (HomeMarketView *)marketView {
    if (!_marketView) {
        _marketView = [[HomeMarketView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 420)];
        WeakSelf
        [_marketView setOnCheckKlineBlock:^(NSString * _Nonnull symbol) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(viewWithCheckKline:)]) {
                [weakSelf.delegate performSelector:@selector(viewWithCheckKline:) withObject:symbol];
            }
        }];
        [_marketView setOnDidSelectContractOrCoinBlock:^(NSString * _Nonnull type) {
            [(HomeMainViewModel *)weakSelf.mainViewModel setQuotesType:type];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(viewWithCheckContractOrCoin)]) {
                [weakSelf.delegate performSelector:@selector(viewWithCheckContractOrCoin)];
            }
        }];
    }
    return _marketView;
}

@end
