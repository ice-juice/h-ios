//
//  PhoneCodeViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/11.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PhoneCodeViewController.h"

#import "PhoneCodeMainView.h"

#import "PhoneCodeModel.h"
#import "LoginMainViewModel.h"

@interface PhoneCodeViewController ()<PhoneCodeMainViewDelegate>
@property (nonatomic, strong) PhoneCodeMainView *mainView;
@property (nonatomic, strong) LoginMainViewModel *mainViewModel;

@end

@implementation PhoneCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhoneCodeData];
}

#pragma mark - Http Request
- (void)fetchPhoneCodeData {
    //获取手机区号
    [self.mainViewModel fetchPhoneCodeWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - PhoneCodeMainViewDelegate
- (void)tableView:(UITableView *)tableView selectPhoneCode:(NSString *)code {
    if ([NSString isEmpty:code]) {
        PhoneCodeModel *codeModel = [(LoginMainViewModel *)self.mainViewModel arrayPhoneCodeDatas][0];
        code = codeModel.code;
    }
    
    if (self.onSelectPhoneCodeBlock) {
        self.onSelectPhoneCodeBlock(code);
    }
    
    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf popViewController];
    });
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"国家/地区", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (PhoneCodeMainView *)mainView {
    if (!_mainView) {
        _mainView = [[PhoneCodeMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (LoginMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[LoginMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
