//
//  AuthenticationViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "UploadPhotosViewController.h"

#import "AuthenticationMainView.h"

#import "HomeMainViewModel.h"

@interface AuthenticationViewController ()<AuthenticationMainViewDelegate>
@property (nonatomic, strong) AuthenticationMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - AuthenticationMainViewDelegate
//- (void)mainViewWithType:(NSString *)type withAccount:(NSString *)account withXing:(NSString *)xing withMing:(NSString *)ming {
//    //上传照片
//    UploadPhotosViewController *uploadPhotosVC = [[UploadPhotosViewController alloc] init];
//    uploadPhotosVC.mainViewModel = self.mainViewModel;
//    [self.navigationController pushViewController:uploadPhotosVC animated:YES];
//}

- (void)mainViewWithNext {
    //上传照片
    UploadPhotosViewController *uploadPhotosVC = [[UploadPhotosViewController alloc] init];
    uploadPhotosVC.mainViewModel = self.mainViewModel;
    [self.navigationController pushViewController:uploadPhotosVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"身份认证", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (AuthenticationMainView *)mainView {
    if (!_mainView) {
        _mainView = [[AuthenticationMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
