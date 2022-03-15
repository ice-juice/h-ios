//
//  LanguageViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/26.
//  Copyright © 2020 zy. All rights reserved.
//

#import "LanguageViewController.h"

#import "LanguageMainView.h"

@interface LanguageViewController ()<LanguageMainViewDelegate>

@property (nonatomic, strong) LanguageMainView *mainView;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"语言", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - LanguageMainViewDelegate
- (void)tableView:(UITableView *)tableView didSelectedIndex:(NSIndexPath *)indexPath {
    if ([[AppDelegate sharedDelegate] isLogin]) {
        [[AppDelegate sharedDelegate] showMainPage];
    } else {
        [[AppDelegate sharedDelegate] showLoginPage];
    }
}

#pragma mark - Setter & Getter
- (LanguageMainView *)mainView {
    if (!_mainView) {
        _mainView = [[LanguageMainView alloc] initWithDelegate:self];
    }
    return _mainView;
}


@end
