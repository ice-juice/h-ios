//
//  HomeViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "HomeViewController.h"
#import "FiatViewController.h"
#import "KLineViewController.h"
#import "WithdrawViewController.h"
#import "RechargeViewController.h"
#import "NoticeListViewController.h"
#import "NoticeDetailViewController.h"
#import "InvitationLinkViewController.h"
#import "PersonalCenterViewController.h"

#import "HomeNewMainView.h"

#import "NewModel.h"
#import "HomeMainViewModel.h"

@interface HomeViewController ()<HomeNewMainViewDelegate>
@property (nonatomic, strong) HomeNewMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //检测本地是否有缓存的数据
    if ([self.mainViewModel hasCacheData]) {
        [self.mainView updateHeaderView];
    }
    [self timeAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchHomeInfoData];
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

#pragma mark - Request Data
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
    [self.mainViewModel fetchContractPricesWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateContractView];
        }
    }];
    
    [self.mainViewModel fetchQuotesWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

- (void)fetchHomeInfoData {
    [self.mainViewModel fetchHomeInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateHeaderView];
        }
    }];
}

#pragma mark - HomeMainViewDelegate
- (void)viewWithCheckHelpCenter {
    //帮助中心
    NoticeListViewController *noticeListVC = [[NoticeListViewController alloc] init];
    noticeListVC.listType = 1;
    [self.navigationController pushViewController:noticeListVC animated:YES];
}

- (void)viewWithCheckNotice {
    //公告平台
    NoticeListViewController *noticeListVC = [[NoticeListViewController alloc] init];
    noticeListVC.listType = 0;
    [self.navigationController pushViewController:noticeListVC animated:YES];
}

- (void)viewWithCheckFiat {
    //法币
    FiatViewController *fiatVC = [[FiatViewController alloc] init];
    [self.navigationController pushViewController:fiatVC animated:YES];
}

- (void)viewWithCheckRecharge {
    //充币
    RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
    rechargeVC.symbol = @"USDT-ERC20";
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)viewWithCheckWithdraw {
    //提币
    WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
    withdrawVC.symbol = @"USDT";
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

- (void)viewWithCheckInviteFriend {
    //邀请好友
    InvitationLinkViewController *inviteLinkVC = [[InvitationLinkViewController alloc] init];
    [self.navigationController pushViewController:inviteLinkVC animated:YES];
}

- (void)viewWithScrollView:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y < 10) {
        self.navBar.backgroundColor = [UIColor clearColor];
    } else {
        self.navBar.backgroundColor = kRGB(0, 102, 237);
    }
}

- (void)viewWithCheckContractOrCoin {
    //查看合约或币币行情
    [self timeAction];
}

- (void)viewWithCheckKline:(NSString *)symbol {
    //查看k线(币币、合约)
    KLineViewController *kLineVC = [[KLineViewController alloc] init];
    kLineVC.symbol = symbol;
    kLineVC.type = self.mainViewModel.quotesType;
    [self.navigationController pushViewController:kLineVC animated:YES];
}

- (void)viewWithCheckContractKline:(NSString *)symbol {
    //合约
    KLineViewController *kLineVC = [[KLineViewController alloc] init];
    kLineVC.symbol = symbol;
    kLineVC.type = @"1";
    [self.navigationController pushViewController:kLineVC animated:YES];
}

- (void)viewWithSelectBanner:(NSString *)link {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    }
}

- (void)viewWithCheckNoticeDetail:(NSString *)index {
    //查看公告详情
    NSInteger selectIndex = [index integerValue];
    NewModel *newModel = self.mainViewModel.arrayNewDatas[selectIndex];
    NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
    detailVC.newsModel = newModel;
    detailVC.listType = 0;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Event Response
- (void)onBtnWithPersonalCenterEvent:(UIButton *)btn {
    //个人中心
    PersonalCenterViewController *personalCenterVC = [[PersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:personalCenterVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    UIButton *btnPersonal = [UIButton buttonWithImageName:@"grzx" highlightedImageName:@"grzx" target:self selector:@selector(onBtnWithPersonalCenterEvent:)];
    btnPersonal.custom_acceptEventInterval = 2;
    self.navBar.navLeftView = btnPersonal;
    self.navBar.title = @"HiEx Global";
    self.navBar.backgroundColor = [UIColor clearColor];
    self.navBar.titleColor = [UIColor whiteColor];
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Setter & Getter
- (HomeNewMainView *)mainView {
    if (!_mainView) {
        _mainView = [[HomeNewMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (HomeMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[HomeMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
