//
//  NoticeListViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeDetailViewController.h"

#import "NoticeListMainView.h"

#import "HomeMainViewModel.h"

@interface NoticeListViewController ()<NoticeListMainViewDelegate>
@property (nonatomic, strong) NoticeListMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.listType == 0) {
        [self fetchNoticeListData];
    } else {
        [self fetchHelpListData];
    }
}

#pragma mark - Request Data
- (void)fetchNoticeListData {
    //公告列表
    [self.mainViewModel fetchNoticeListWithResult:^(BOOL success, BOOL loadMore) {
        if (success) {
            [self.mainView updateView];
        }
        [self.mainView showFooterView:loadMore];
    }];
}

- (void)fetchHelpListData {
    //帮助中心
    [self.mainViewModel fetchHelpListWithResult:^(BOOL success, BOOL loadMore) {
        if (success) {
            [self.mainView updateView];
        }
        [self.mainView showFooterView:loadMore];
    }];
}

#pragma mark - NoticeListMainViewDelegate
- (void)tableView:(UITableView *)tableView checkNoticeDetail:(NewModel *)newModel {
    // 查看公告详情
    NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
    detailVC.newsModel = newModel;
    detailVC.listType = self.listType;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)pullUpHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo ++;
    if (self.listType == 0) {
        [self fetchNoticeListData];
    } else {
        [self fetchHelpListData];
    }
}

- (void)pullDownHandleOfContentView:(UIView *)contentView {
    self.mainViewModel.pageNo = 1;
    if (self.listType == 0) {
        [self fetchNoticeListData];
    } else {
        [self fetchHelpListData];
    }
}

#pragma mark - Super Class
- (void)setupNavigation {
    NSString *title = self.listType == 0 ? @"平台公告" : @"帮助中心";
    self.navBar.title = title;
    self.navBar.titleColor = kRGB(16, 16, 16);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (NoticeListMainView *)mainView {
    if (!_mainView) {
        _mainView = [[NoticeListMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
