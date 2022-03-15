//
//  KLineViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "KLineViewController.h"
#import "DepthViewController.h"
#import "CurrencyDropDownView.h"
#import "AMPageController.h"
#import "UpdateDealViewController.h"
#import "IntroductionViewController.h"

#import "BaseScrollView.h"
#import "KLineTableHeaderView.h"

#import "Service.h"
#import "KLineMainViewModel.h"

#import "YYKline.h"

#import "ZYTimerProxyTarget.h"

#import "WebsocketStompKit.h"

#define kHeaderViewHeight 592

@interface KLineViewController ()<UIScrollViewDelegate, KLineTableHeaderViewDelegate, AMPageControllerDelegate, AMPageControllerDataSource, STOMPClientDelegate>
@property (nonatomic, strong) UIButton *btnSymbol;

@property (nonatomic, strong) CurrencyDropDownView *dropDownView;
@property (nonatomic, strong) AMPageController *pageController;

@property (nonatomic, strong) BaseScrollView *containerScrollView;
@property (nonatomic, strong) KLineTableHeaderView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) YYKlineView *kLineView;

@property (nonatomic, strong) KLineMainViewModel *mainViewModel;

@property (nonatomic, strong) NSArray *arrayIndicatorDatas;

@property (nonatomic, assign) BOOL isFenShi;
@property (nonatomic, assign) BOOL canScroll;

//返回数据时间粒度（15min, 60min, 4hour, 1day）(默认15min)
@property (nonatomic, copy) NSString *period;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ZYTimerProxyTarget *proxyTarget;

@property (nonatomic, strong) STOMPClient *client;

@end

@implementation KLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _canScroll = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kNotificationQuotesLevelTop object:nil];
    
    self.period = @"15min";
    
    self.isFenShi = NO;
    
    [self fetchKLineData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self callTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - HTTP Request
- (void)callTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        //创建消息循环
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        //将定时器添加到runLoop
        [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)timeAction {
    [self fetchKLineData];
}

- (void)fetchKLineData {
    //获取某个币种的k线图数据
    NSDictionary *params1 = @{@"symbol" : self.mainViewModel.symbol,
                             @"period" : self.period,
                             @"size" : @(500),
                             @"type" : self.type
    };
    [Service fetchKLineWithParams:params1 mapper:[YYKlineModel class] showHUD:NO success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            NSArray *tempArray = responseModel.data;
            if ([self.type isEqualToString:@"0"]) {
                //币币数据需要倒序
                tempArray = [[tempArray reverseObjectEnumerator] allObjects];
            }
            YYKlineRootModel *groupModel = [YYKlineRootModel objectWithArray:tempArray];
            self.kLineView.rootModel = groupModel;
            self.kLineView.linePainter = self.isFenShi ? YYTimelinePainter.class : YYCandlePainter.class;
            [self.kLineView reDraw];
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取某个币种的k线图数据失败");
    }];
    
    [self.mainViewModel fetchSymbolQuotesWithResult:^(BOOL success) {
        if (success) {
            [self.headerView updateView];
            [self.dropDownView setViewWithModel:self.mainViewModel.arrayQuotesDatas];
        }
    }];
}

#pragma mark - KLineTableHeaderViewDelegate
- (void)onDidSelectTimeAtIndex:(NSString *)index {
    //选择时间
    NSInteger selectIndex = [index integerValue];
    if (selectIndex == 0) {
        self.isFenShi = YES;
        [self setPeriod:@"1min"];
        //2020-12-07去掉MA5、MA10、MA30三根线
        self.kLineView.indicator1Painter = nil;
    } else {
        self.isFenShi = NO;
        if (selectIndex == 1) {
            [self setPeriod:@"15min"];
        } else if (selectIndex == 2) {
            [self setPeriod:@"60min"];
        } else if (selectIndex == 3) {
            [self setPeriod:@"4hour"];
        } else if (selectIndex == 4) {
            [self setPeriod:@"1day"];
        }
    }
    [self fetchKLineData];
}

- (void)onDidSelectMoreAtIndex:(NSString *)index {
    //更多
    self.isFenShi = NO;
    NSInteger selectIndex = [index integerValue];
    if (selectIndex == 0) {
        [self setPeriod:@"1min"];
    } else if (selectIndex == 1) {
        [self setPeriod:@"5min"];
    } else if (selectIndex == 2) {
        [self setPeriod:@"30min"];
    } else if (selectIndex == 3) {
        [self setPeriod:@"1week"];
    } else if (selectIndex == 4){
        [self setPeriod:@"1mon"];
    }
    [self fetchKLineData];
}

- (void)onDidSelectZhiBiaoAtIndex:(NSString *)index {
    //指标
    switch ([index integerValue]) {
        case 0:
        {
            self.kLineView.indicator2Painter = YYMACDPainter.class;
        }
            break;
        case 1:
        {
            self.kLineView.indicator1Painter = YYEMAPainter.class;
        }
            break;
        case 2:
        {
            self.kLineView.indicator1Painter = YYBOLLPainter.class;
        }
            break;
        case 3:
        {
            self.kLineView.indicator2Painter = YYKDJPainter.class;
        }
            break;

        default:
            self.kLineView.indicator1Painter = nil;
            break;
    }
    [self.kLineView reDraw];
}

#pragma mark - AMPageControllerDelegate
- (NSInteger)numbersOfChildControllersInPageController:(AMPageController *)pageController {
    return [self.arrayIndicatorDatas count];
}

- (__kindof UIViewController *)pageController:(AMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        //盘口深度
        DepthViewController *vc = [[DepthViewController alloc] init];
        vc.symbol = self.mainViewModel.symbol;
        vc.type = self.mainViewModel.type;
        return vc;
    } else if (index == 1) {
        //最新成交
        UpdateDealViewController *vc = [[UpdateDealViewController alloc] init];
        vc.symbol = self.mainViewModel.symbol;
        return vc;
    } else if (index == 2) {
        //合约简介
        IntroductionViewController *vc = [[IntroductionViewController alloc] init];
        vc.symbol = self.mainViewModel.symbol;
        return vc;
    }
    return [[BaseViewController alloc] init];
}

- (NSString *)pageController:(AMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.arrayIndicatorDatas[index];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat maxOffsetY = kHeaderViewHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    self.headerView.scrollValue = offsetY;
    if (offsetY >= maxOffsetY) {
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationQuotesGoTop object:nil userInfo:@{@"canScroll":@"1"}];
        _canScroll = NO;
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        }
    }
}

#pragma mark - NSNotification
- (void)acceptMsg:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

#pragma mark - Event Response
- (void)onBtnWithSelectSymbolEvent:(UIButton *)btn {
    //选择币种
    [self.dropDownView showView];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.backgroundColor = kRGB(10, 22, 39);
    self.navBar.returnType = NavReturnTypeWhite;
    
    UIView *titleView = [[UIView alloc] init];
    
    NSString *title = [self.type isEqualToString:@"0"] ? @"" : @"永续";
        
    self.btnSymbol = [UIButton buttonWithTitle:[NSString stringWithFormat:@"%@%@", self.symbol, NSLocalizedString(title, nil)] titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(16, 16, 16) font:kBoldFont(18) target:self selector:@selector(onBtnWithSelectSymbolEvent:)];
    [self.btnSymbol setImage:[StatusHelper imageNamed:@"bibi-xl"] forState:UIControlStateNormal];
    [titleView addSubview:self.btnSymbol];
    [self.btnSymbol makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.centerX.equalTo(0);
        make.height.equalTo(25);
        make.width.equalTo(150);
    }];
    [self.btnSymbol setTitleLeftSpace:5];
    
    UILabel *lbUSDT = [UILabel labelWithText:NSLocalizedString(@"USDT结算", nil) textColor:kRGB(255, 255, 255) font:kFont(9)];
    [titleView addSubview:lbUSDT];
    [lbUSDT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnSymbol.mas_bottom);
        make.centerX.equalTo(0);
    }];
    
    lbUSDT.hidden = [self.type isEqualToString:@"0"] ? YES : NO;
    
    self.navBar.titleView = titleView;
}

- (void)setupSubViews {
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    [self.containerScrollView addSubview:self.headerView];
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(152);
    }];
    
    [self.containerScrollView addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kHeaderViewHeight);
        make.left.right.bottom.equalTo(0);
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(kScreenHeight);
    }];
    
    [self addChildViewController:self.pageController];
    [self.contentView addSubview:self.pageController.view];
    self.pageController.viewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Setter & Getter
- (KLineTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[KLineTableHeaderView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _headerView;
}

- (BaseScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[BaseScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.backgroundColor = kRGB(3, 14, 30);
        _containerScrollView.showsVerticalScrollIndicator = NO;
        _containerScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _containerScrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (CurrencyDropDownView *)dropDownView {
    if (!_dropDownView) {
        _dropDownView = [[CurrencyDropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_dropDownView setOnDidSelectSymbolAtIndexBlock:^(NSString * _Nonnull symbol) {
            //选择币种
            weakSelf.mainViewModel.symbol = symbol;
            
            NSString *title = [weakSelf.type isEqualToString:@"0"] ? @"" : @"永续";
            [weakSelf.btnSymbol setTitle:[NSString stringWithFormat:@"%@%@", symbol, NSLocalizedString(title, nil)] forState:UIControlStateNormal];
            
            [weakSelf fetchKLineData];
            [weakSelf.pageController reloadData];
        }];
    }
    return _dropDownView;
}

- (AMPageController *)pageController {
    if (!_pageController) {
        _pageController = [[AMPageController alloc] init];
        _pageController.delegate = self;
        _pageController.dataSource = self;
        _pageController.progressWidth = 40;
        _pageController.titleSizeNormal = 14;
        _pageController.titleSizeSelected = 14;
        _pageController.titleColorNormal = kRGB(125, 145, 171);
        _pageController.titleColorSelected = kRGB(255, 255, 255);
        _pageController.menuItemWidth = kScreenWidth / 3;
        _pageController.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        _pageController.menuHeight = 32;
        _pageController.menuBGColor = kRGB(10, 22, 39);
        _pageController.progressColor = kRGB(10, 22, 39);
    }
    return _pageController;
}

- (YYKlineView *)kLineView {
    if (!_kLineView) {
        _kLineView = [[YYKlineView alloc] initWithFrame:CGRectMake(0, 152, kScreenWidth, 440)];
        [self.containerScrollView addSubview:_kLineView];
    }
    return _kLineView;
}

- (KLineMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[KLineMainViewModel alloc] initWithSymbol:self.symbol type:self.type];
    }
    return _mainViewModel;
}

- (NSArray *)arrayIndicatorDatas {
    if (!_arrayIndicatorDatas) {
        if ([self.type isEqualToString:@"0"]) {
            _arrayIndicatorDatas = @[@"盘口深度"];
        } else {
            _arrayIndicatorDatas = @[@"盘口深度", @"最新成交", @"合约简介"];
        }
    }
    return _arrayIndicatorDatas;
}

@end
