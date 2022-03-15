//
//  InvitationLinkViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "InvitationLinkViewController.h"

#import "InvitationLinkMainView.h"

@interface InvitationLinkViewController ()
@property (nonatomic, strong) InvitationLinkMainView *mainView;

@end

@implementation InvitationLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainView updateView];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"邀请链接", nil);
    self.navBar.backgroundColor = [UIColor clearColor];
    self.navBar.returnType = NavReturnTypeWhite;
    self.navBar.titleColor = [UIColor whiteColor];
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Setter & Getter
- (InvitationLinkMainView *)mainView {
    if (!_mainView) {
        _mainView = [[InvitationLinkMainView alloc] init];
    }
    return _mainView;
}

@end
