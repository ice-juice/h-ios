//
//  UpdateDealViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/4.
//  Copyright © 2020 zy. All rights reserved.
//

#import "UpdateDealViewController.h"

#import "UpdateDealMainView.h"

#import "KLineMainViewModel.h"

@interface UpdateDealViewController ()<UpdateDealMainViewDelegate>
@property (nonatomic, strong) UpdateDealMainView *mainView;
@property (nonatomic, strong) KLineMainViewModel *mainViewModel;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation UpdateDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kNotificationQuotesGoTop object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kNotificationQuotesLevelTop object:nil];//其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
    [self timeAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timeAction {
    [self fetchUpdateDealData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification
-(void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kNotificationQuotesGoTop]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
        }
    } else if([notificationName isEqualToString:kNotificationQuotesLevelTop]){
        self.mainView.tableView.contentOffset = CGPointZero;
        self.canScroll = NO;
    }
}

- (void)switchSymbol:(NSNotification *)noti {
    [self fetchUpdateDealData];
}

#pragma mark - CommissionMainViewDelegate
- (void)tableView:(UITableView *)tableView scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationQuotesLevelTop object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

#pragma mark - Http Request
- (void)fetchUpdateDealData {
    [self.mainViewModel fetchContractNewPriceWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.hiddenNavBar = YES;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (UpdateDealMainView *)mainView {
    if (!_mainView) {
        _mainView = [[UpdateDealMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (KLineMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[KLineMainViewModel alloc] initWithSymbol:self.symbol];
    }
    return _mainViewModel;
}

@end
