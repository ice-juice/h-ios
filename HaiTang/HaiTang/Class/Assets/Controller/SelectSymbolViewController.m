//
//  SelectSymbolViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SelectSymbolViewController.h"

#import "SelectSymbolMainView.h"

#import "AssetsMainViewModel.h"

@interface SelectSymbolViewController ()<SelectSymbolMainViewDelegate>
@property (nonatomic, strong) SelectSymbolMainView *mainView;
@property (nonatomic, strong) AssetsMainViewModel *mainViewModel;

@end

@implementation SelectSymbolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchSymbolListData];
}

#pragma mark - Request Data
- (void)fetchSymbolListData {
    [self.mainViewModel fetchSymbolListWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - SelectSymbolMainViewDelegate
- (void)tableView:(UITableView *)tableView selectSymbol:(NSString *)symbol {
    if (self.onSelectedSymbolBlock) {
        self.onSelectedSymbolBlock(symbol);
    }
    [self popViewController];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"币种选择", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (SelectSymbolMainView *)mainView {
    if (!_mainView) {
        _mainView = [[SelectSymbolMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (AssetsMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[AssetsMainViewModel alloc] initWithSymbol:self.symbol type:self.type];
    }
    return _mainViewModel;
}

@end
