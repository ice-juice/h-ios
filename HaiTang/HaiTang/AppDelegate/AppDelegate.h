//
//  AppDelegate.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL keyboardEnable;

+ (AppDelegate *)sharedDelegate;
- (BOOL)isNetworkReachable;
- (void)showMainPage;
- (void)showMinePage;
- (void)showLoginPage;
- (BOOL)isIphoneX;
- (BOOL)isLogin;
- (void)logout;
- (void)forcedToUpdate;

@end

