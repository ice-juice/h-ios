//
//  NoticeDetailViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NoticeDetailViewController.h"

#import "NoticeDetailMainView.h"

@interface NoticeDetailViewController ()
@property (nonatomic, strong) NoticeDetailMainView *mainView;

@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

#pragma mark - Super Class
- (void)setupNavigation {
    NSString *title = self.listType == 0 ? @"平台公告" : @"帮助中心";
    self.navBar.title = title;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (NoticeDetailMainView *)mainView {
    if (!_mainView) {
        _mainView = [[NoticeDetailMainView alloc] initWithNewModel:self.newsModel];
    }
    return _mainView;
}

@end
