//
//  ContractViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ContractViewController.h"
#import "RecordsViewController.h"
#import "KLineViewController.h"
#import "InvitationLinkViewController.h"

#import "ContractMainView.h"
#import "CurrencyDropDownView.h"
#import "ContractTableHeaderView.h"

#import "ContractMainViewModel.h"

@interface ContractViewController ()<ContractMainViewDelegate>
@property (nonatomic, strong) UIButton *btnSymbol;
@property (nonatomic, strong) ContractMainView *mainView;
@property (nonatomic, strong) CurrencyDropDownView *dropDownView;
@property (nonatomic, strong) ContractMainViewModel *mainViewModel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchContractInfoData];
    [self timeAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mainViewModel.symbols = @"BTC/USDT";

    [self.btnSymbol setTitle:[NSString stringWithFormat:@"BTC/USDT%@", NSLocalizedString(@"永续", nil)] forState:UIControlStateNormal];
    
    [self fetchContractInfoData];
    
    [self.mainView.tableHeaderView updateView];
    
    if (!self.timer) {
         self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    }
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
- (void)timeAction {
    [self.mainView.tableHeaderView timeAction];
    [self fetchContractMarketAndOrderListData];
}

- (void)fetchContractInfoData {
    //获取合约页面信息
    [self.mainViewModel fetchContractInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView.tableHeaderView setViewWithModel:self.mainViewModel.contractInfoModel];
        }
    }];
}

- (void)fetchContractMarketAndOrderListData {
    //获取币种行情
    [self.mainViewModel fetchContractMarketWithResult:^(BOOL success) {
        if (success) {
            [self.dropDownView setViewWithModel:self.mainViewModel.arrayQuotesDatas];
            [self.mainView.tableHeaderView setViewQuotesWithModel:[self.mainViewModel currentQuotesModel]];
        }
    }];
    
    //合约订单列表数据
    [self.mainViewModel fetchContractOrderListWithResult:^(BOOL success, BOOL loadMore) {
        if (success) {
            [self.mainView updateView];
        }
        [self.mainView showFooterView:loadMore];
    }];
}

- (void)fetchTakeProfit:(NSString *)profitPrice stopLoss:(NSString *)lossPrice {
    //止盈止损
    [self.mainViewModel fetchTakeProfit:profitPrice stopLoss:lossPrice result:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"设置成功", nil) completionHandle:^{
                [self fetchContractMarketAndOrderListData];
            }];
        }
    }];
}

#pragma mark - ContractMainViewDelegate
- (void)tableViewWithCheckCloseRecords:(UITableView *)tableView {
    //平仓记录
    RecordsViewController *recordsVC = [[RecordsViewController alloc] init];
    recordsVC.recordType = RecordTypeCloseing;
    recordsVC.symbols = @"";
    [self.navigationController pushViewController:recordsVC animated:YES];
}

- (void)tableViewWithCheckContractOrderList:(UITableView *)tableView {
    //查看合约订单列表
    self.mainViewModel.pageNo = 1;
    [self fetchContractMarketAndOrderListData];
}

- (void)tableViewWithSubmitContract:(UITableView *)tableView {
    //下单
    WeakSelf
    [self.mainViewModel fetchSubmitContractWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"操作成功", nil) completionHandle:^{
                [weakSelf fetchContractInfoData];
            }];
        }
    }];
}

- (void)tableViewWithCloseing:(UITableView *)tableView {
    //平仓
    [self.mainViewModel fetchCloseingWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"平仓成功", nil) completionHandle:^{
                [self fetchContractMarketAndOrderListData];
            }];
        }
    }];
}

- (void)tableViewWithCancelContract:(UITableView *)tableView {
    //撤销合约委托
    [self.mainViewModel fetchCancelContractWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"撤销成功", nil) completionHandle:^{
                [self fetchContractMarketAndOrderListData];
            }];
        }
    }];
}

- (void)tableView:(UITableView *)tableView setTakeProfit:(NSString *)profitPrice stopLoss:(NSString *)lossPrice {
    //止盈止损
    [self fetchTakeProfit:profitPrice stopLoss:lossPrice];
}

#pragma mark - Event Response
- (void)onBtnWithCheckKLineEvent:(UIButton *)btn {
    //k线
    KLineViewController *kLineVC = [[KLineViewController alloc] init];
    kLineVC.symbol = self.mainViewModel.symbols;
    kLineVC.type = @"1";
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
    
    self.btnSymbol = [UIButton buttonWithTitle:[NSString stringWithFormat:@"BTC/USDT%@", NSLocalizedString(@"永续", nil)] titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kBoldFont(18) target:self selector:@selector(onBtnWithSelectSymbolEvent:)];
    [self.btnSymbol setImage:[StatusHelper imageNamed:@"bibi-xl"] forState:UIControlStateNormal];
    [titleView addSubview:self.btnSymbol];
    [self.btnSymbol makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.centerX.equalTo(0);
        make.height.equalTo(25);
    }];
    [self.btnSymbol setTitleLeftSpace:5];
    
    UILabel *lbUSDT = [UILabel labelWithText:NSLocalizedString(@"USDT结算", nil) textColor:kRGB(16, 16, 16) font:kFont(9)];
    [titleView addSubview:lbUSDT];
    [lbUSDT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnSymbol.mas_bottom);
        make.centerX.equalTo(0);
    }];
    
    self.navBar.titleView = titleView;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (ContractMainView *)mainView {
    if (!_mainView) {
        _mainView = [[ContractMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (CurrencyDropDownView *)dropDownView {
    if (!_dropDownView) {
        _dropDownView = [[CurrencyDropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_dropDownView setOnDidSelectSymbolAtIndexBlock:^(NSString * _Nonnull symbol) {
            //选择币种
            [weakSelf.btnSymbol setTitle:[NSString stringWithFormat:@"%@%@", symbol, NSLocalizedString(@"永续", nil)] forState:UIControlStateNormal];
            weakSelf.mainViewModel.symbols = symbol;
            [weakSelf fetchContractInfoData];
            [weakSelf fetchContractMarketAndOrderListData];
        }];
    }
    return _dropDownView;
}

- (ContractMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[ContractMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
