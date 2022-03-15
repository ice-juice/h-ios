//
//  CoinViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CoinViewController.h"
#import "KLineViewController.h"
#import "RecordsViewController.h"

#import "CoinMainView.h"
#import "CoinTableHeaderView.h"
#import "CurrencyDropDownView.h"

#import "CoinMainViewModel.h"

@interface CoinViewController ()<CoinMainViewDelegate>
@property (nonatomic, strong) UIButton *btnSymbol;
@property (nonatomic, strong) CoinMainView *mainView;

@property (nonatomic, strong) CurrencyDropDownView *dropDownView;

@property (nonatomic, strong) CoinMainViewModel *mainViewModel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchCoinInfoData];
    [self timeAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mainViewModel.type = @"BTC/USDT";
    [self.btnSymbol setTitle:@"BTC/USDT" forState:UIControlStateNormal];
    [self.btnSymbol setTitleLeftSpace:7];
    self.mainView.tableHeaderView.symbols = @"BTC/USDT";

    [self fetchCoinInfoData];
    [self startTimer];
    
    [self.mainView.tableHeaderView updateView];
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

- (void)startTimer {
    if (!self.timer) {
         self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    }
}

- (void)timeAction {
    [self fetchQuotesData];
    [self.mainView.tableHeaderView timeAction];
}

#pragma mark - Request Data
- (void)fetchCoinInfoData {
    //币币交易页面信息
    [self.mainViewModel fetchCoinInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView.tableHeaderView setViewWithModel:[self.mainViewModel coinInfoModel]];
        }
    }];
}

- (void)fetchQuotesData {
    //获取币种行情
    [self.mainViewModel fetchQuotesWithResult:^(BOOL success) {
        if (success) {
            [self.dropDownView setViewWithModel:self.mainViewModel.arrayQuotesDatas];
            [self.mainView.tableHeaderView setViewQuotesWithModel:[self.mainViewModel currentQuotesModel]];
        }
    }];
    
    //当前委托
    [self.mainViewModel fetchCommissionWithResult:^(BOOL success, BOOL loadMore) {
        if (success) {
            [self.mainView updateView];
        }
        [self.mainView showFooterView:loadMore];
    }];
}

#pragma mark - CoinMainViewDelegate
- (void)tableViewWithCheckDealRecord:(UITableView *)tableView {
    //成交记录
    RecordsViewController *recordVC = [[RecordsViewController alloc] init];
    recordVC.recordType = RecordTypeDeal;
    recordVC.symbols = @"";
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)tableViewWithDidSelectMatchType:(UITableView *)tableView {
    //切换交易类型
    [self fetchCoinInfoData];
}

- (void)tableView:(UITableView *)tableView submitDealWithPrice:(NSString *)price number:(NSString *)number {
    //交易
    [self.mainViewModel fetchSubmitDealWithPrice:price number:number result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"委托成功", nil) completionHandle:^{
                [self timeAction];
            }];
        }
    }];
}

- (void)tableViewWithCancelContract:(UITableView *)tableView {
    //撤销委托
    [self.mainViewModel fetchRevocationCommissionWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"撤销成功", nil) completionHandle:^{
                [self fetchQuotesData];
            }];
        }
    }];
}

#pragma mark - Event Response
- (void)onBtnWithCheckKLineEvent:(UIButton *)btn {
    //k线
    KLineViewController *kLineVC = [[KLineViewController alloc] init];
    kLineVC.symbol = self.mainViewModel.type;
    kLineVC.type = @"0";
    [self.navigationController pushViewController:kLineVC animated:YES];
}

- (void)onBtnWithSelectSymbolEvent:(UIButton *)btn {
    //选择币种
    [self.dropDownView showView];
}

#pragma mark - Super Class
- (void)setupNavigation {
    UIButton *btnKLine = [UIButton buttonWithImageName:@"trade_kline_normal" highlightedImageName:@"trade_kline_normal" target:self selector:@selector(onBtnWithCheckKLineEvent:)];
    self.navBar.navRightView = btnKLine;
    
    UIView *titleView = [[UIView alloc] init];
    
    self.btnSymbol = [UIButton buttonWithTitle:@"BTC/USDT" titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kBoldFont(18) target:self selector:@selector(onBtnWithSelectSymbolEvent:)];
    [self.btnSymbol setImage:[StatusHelper imageNamed:@"bibi-xl"] forState:UIControlStateNormal];
    [titleView addSubview:self.btnSymbol];
    [self.btnSymbol makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    [self.btnSymbol setTitleLeftSpace:5];

    self.navBar.titleView = titleView;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (CoinMainView *)mainView {
    if (!_mainView) {
        _mainView = [[CoinMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (CoinMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[CoinMainViewModel alloc] init];
    }
    return _mainViewModel;
}

- (CurrencyDropDownView *)dropDownView {
    if (!_dropDownView) {
        _dropDownView = [[CurrencyDropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_dropDownView setOnDidSelectSymbolAtIndexBlock:^(NSString * _Nonnull symbol) {
            //选择币种
            [weakSelf.btnSymbol setTitle:symbol forState:UIControlStateNormal];
            [weakSelf.btnSymbol setTitleLeftSpace:5];
            weakSelf.mainViewModel.type = symbol;
            [weakSelf fetchCoinInfoData];
            [weakSelf fetchQuotesData];
        }];
    }
    return _dropDownView;
}

@end
