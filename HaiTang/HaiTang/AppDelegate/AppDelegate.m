//
//  AppDelegate.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfoManager.h"
#import "IQKeyboardManager.h"

#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"

#import "MandatoryUpdateView.h"

#import "Service.h"
#import "AppVersionModel.h"

@interface AppDelegate ()

@property (nonatomic, strong) MandatoryUpdateView *updateView;
@property (nonatomic, copy) NSString *updateUrl;        //App下载地址

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupSetting];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if (![self isLogin]) {
        [self showLoginPage];
    } else {
        [self showMainPage];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self forcedToUpdate];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self forcedToUpdate];
}

#pragma mark - External Interface
+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)isNetworkReachable {
    if ([YYReachability new].reachable) {
        return YES;
    }
    return NO;
}

- (void)setKeyboardEnable:(BOOL)keyboardEnable {
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = keyboardEnable;
    [IQKeyboardManager sharedManager].enableAutoToolbar = keyboardEnable;
}

- (BOOL)isIphoneX {
    static CGFloat liuHaiHeight = 44;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
        return safeAreaInsets.top == liuHaiHeight || safeAreaInsets.bottom == liuHaiHeight || safeAreaInsets.left == liuHaiHeight || safeAreaInsets.right == liuHaiHeight;
    } else {
        return NO;
    }
}

- (void)showMainPage {
    self.window.rootViewController = nil;
    MainTabBarController *tabBarVC = [[MainTabBarController alloc] init];
    self.window.rootViewController = tabBarVC;
}

- (void)showLoginPage {
    self.window.rootViewController = nil;
    self.window.rootViewController = [[BaseNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
}

- (BOOL)isLogin {
    NSString *userToken = [[NSUserDefaults standardUserDefaults] valueForKey:kToken];
    if ([NSString isEmpty:userToken]) {
        return NO;
    }
    return YES;
}

- (void)logout {
    [[UserInfoManager sharedManager] clearUserInfo];
    [self showLoginPage];
}

- (void)registerInvalidLoginNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kNotificationInvalidToken object:nil];
}

- (void)setupSetting {
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    [self registerInvalidLoginNotification];
    //初始化用户数据
    [[UserInfoManager sharedManager] getUserInfo];
    //初始化语言
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLanguage];
    if ([NSString isEmpty:language]) {
        [[NSUserDefaults standardUserDefaults] setObject:Chinese_Traditional forKey:kCurrentLanguage];
    }
    [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLanguage]];
    // 创建缓存目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:kCachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:kCachePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

#pragma mark - Http Request
- (void)forcedToUpdate {
    //强制更新
    NSDictionary *params = @{@"type" : @"IOS"};
    [Service fetchUpdateAppVersionWithParams:params mapper:[AppVersionModel class] showHUD:NO success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            AppVersionModel *versionModel = responseModel.data;
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if (![appVersion isEqualToString:versionModel.version]) {
                self.updateUrl = versionModel.address;
                [self.updateView showViewWithContent:versionModel.content];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取版本信息失败");
    }];
}

#pragma mark - Setter & Getter
- (MandatoryUpdateView *)updateView {
    if (!_updateView) {
        _updateView = [[MandatoryUpdateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_updateView setOnBtnWithUpdateVersionBlock:^{
            //强制更新
            NSURL *url = [NSURL URLWithString:weakSelf.updateUrl];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }
    return _updateView;
}


@end
