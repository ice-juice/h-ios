//
//  ProtocolViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/20.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ProtocolViewController.h"

#import "ProtocolMainView.h"

#import "LoginMainViewModel.h"

@interface ProtocolViewController ()
@property (nonatomic, strong) ProtocolMainView *mainView;
@property (nonatomic, strong) LoginMainViewModel *mainViewModel;

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchProtocolData];
}

#pragma mark - Request Data
- (void)fetchProtocolData {
    [self.mainViewModel fetchProtocolWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - Super Class
- (void)setupNavigation {
    NSString *title = @"";
    if ([self.type isEqualToString:@"SERVER_INFO"]) {
        title = @"《服务条款》";
    } else if ([self.type isEqualToString:@"white"]) {
        title = @"白皮书";
    } else {
        title = @"《隐私政策》";
    }    
    self.navBar.title = NSLocalizedString(title, nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (ProtocolMainView *)mainView {
    if (!_mainView) {
        _mainView = [[ProtocolMainView alloc] initWithViewModel:self.mainViewModel];
    }
    return _mainView;
}

- (LoginMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[LoginMainViewModel alloc] initWithProtocolType:self.type];
    }
    return _mainViewModel;
}

@end
