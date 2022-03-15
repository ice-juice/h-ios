//
//  UserInfoManager.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import "UserInfoManager.h"
#import "UserModel.h"

#define kAccount                   @"user_account"      //账号
#define kEmail                     @"user_email"        //邮箱
#define kPhonne                    @"user_phone"        //手机
#define kRealStatus                @"user_realStatus"   //是否实名认证 0:未认证 1:已认证 2:审核中
#define kIsOpenPay                 @"user_isOpenPay"    //是否开启资产密码 Y:是 N：否
#define kPaySmsType                @"user_paySmsType"   //资产密码验证方式 PHONE:手机验证 EMAIL:邮箱验证
#define kNickName                  @"user_nickName"     //昵称
#define kRealName                  @"user_realName"     //真实姓名
#define kLoginMethod               @"user_loginMethod"  //登录方式
#define kInviteCode                @"user_inviteCode"   //邀请码
#define kInviteLink                @"user_inviteLink"   //邀请链接

static UserInfoManager *manager;

@implementation UserInfoManager
+ (UserInfoManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserInfoManager alloc] init];
    });
    return manager;;
}

- (id)init {
    if (self = [super init]) {
        NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
        self.account         = [info objectForKey:kAccount];
        self.email           = [info objectForKey:kEmail];
        self.phone           = [info objectForKey:kPhonne];
        self.realStatus      = [info objectForKey:kRealStatus];
        self.isOpenPay       = [info objectForKey:kIsOpenPay];
        self.paySmsType      = [info objectForKey:kPaySmsType];
        self.nickName        = [info objectForKey:kNickName];
        self.realName        = [info objectForKey:kRealName];
        self.loginMethod     = [info objectForKey:kLoginMethod];
        self.inviteCode      = [info objectForKey:kInviteCode];
        self.inviteLink      = [info objectForKey:kInviteLink];
    }
    return self;
}

- (void)clearUserInfo {
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info removeObjectForKey:kToken];
    [info removeObjectForKey:kAccount];
    [info removeObjectForKey:kEmail];
    [info removeObjectForKey:kPhonne];
    [info removeObjectForKey:kRealStatus];
    [info removeObjectForKey:kIsOpenPay];
    [info removeObjectForKey:kPaySmsType];
    [info removeObjectForKey:kNickName];
    [info removeObjectForKey:kRealName];
    [info removeObjectForKey:kLoginMethod];
    [info removeObjectForKey:kInviteCode];
    [info removeObjectForKey:kInviteLink];
    [info synchronize];
    [self getUserInfo];
}

- (UserInfoManager *)getUserInfo {
    UserInfoManager *userInfoManager = [UserInfoManager sharedManager];
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    userInfoManager.account    = [info objectForKey:kAccount];
    userInfoManager.email      = [info objectForKey:kEmail];
    userInfoManager.phone      = [info objectForKey:kPhonne];
    userInfoManager.realStatus = [info objectForKey:kRealStatus];
    userInfoManager.isOpenPay  = [info objectForKey:kIsOpenPay];
    userInfoManager.paySmsType = [info objectForKey:kPaySmsType];
    userInfoManager.nickName   = [info objectForKey:kNickName];
    userInfoManager.realName   = [info objectForKey:kRealName];
    userInfoManager.loginMethod= [info objectForKey:kLoginMethod];
    userInfoManager.inviteCode = [info objectForKey:kInviteCode];
    userInfoManager.inviteLink = [info objectForKey:kInviteLink];
    return userInfoManager;
}

- (void)setUserInfo:(UserModel *)userModel {
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info setObject:userModel.account forKey:kAccount];
    [info setObject:userModel.email forKey:kEmail];
    [info setObject:userModel.phone forKey:kPhonne];
    [info setObject:userModel.realStatus forKey:kRealStatus];
    [info setObject:userModel.isOpenPay forKey:kIsOpenPay];
    [info setObject:userModel.paySmsType forKey:kPaySmsType];
    [info setObject:userModel.nickName forKey:kNickName];
    [info setObject:userModel.realName forKey:kRealName];
    [info setObject:userModel.loginMethod forKey:kLoginMethod];
    [info setObject:userModel.inviteCode forKey:kInviteCode];
    [info setObject:userModel.inviteLink forKey:kInviteLink];
    [info synchronize];
    [self getUserInfo];
}

@synthesize account = _account;
- (void)setAccount:(NSString *)account {
    _account = account;
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:kAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize email = _email;
- (void)setEmail:(NSString *)email {
    _email = email;
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kEmail];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize phone = _phone;
- (void)setPhone:(NSString *)phone {
    _phone = phone;
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:kPhonne];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize realStatus = _realStatus;
- (void)setRealStatus:(NSString *)realStatus {
    _realStatus = realStatus;
    [[NSUserDefaults standardUserDefaults] setObject:realStatus forKey:kRealStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize isOpenPay = _isOpenPay;
- (void)setIsOpenPay:(NSString *)isOpenPay {
    _isOpenPay = isOpenPay;
    [[NSUserDefaults standardUserDefaults] setObject:isOpenPay forKey:kIsOpenPay];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize paySmsType = _paySmsType;
- (void)setPaySmsType:(NSString *)paySmsType {
    _paySmsType = paySmsType;
    [[NSUserDefaults standardUserDefaults] setObject:paySmsType forKey:kPaySmsType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize nickName = _nickName;
- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:kNickName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize realName = _realName;
- (void)setRealName:(NSString *)realName {
    _realName = realName;
    [[NSUserDefaults standardUserDefaults] setObject:realName forKey:kRealName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize loginMethod = _loginMethod;
- (void)setLoginMethod:(NSString *)loginMethod {
    _loginMethod = loginMethod;
    [[NSUserDefaults standardUserDefaults] setObject:loginMethod forKey:kLoginMethod];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize inviteCode = _inviteCode;
- (void)setInviteCode:(NSString *)inviteCode {
    _inviteCode = inviteCode;
    [[NSUserDefaults standardUserDefaults] setObject:inviteCode forKey:kInviteCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@synthesize inviteLink = _inviteLink;
- (void)setInviteLink:(NSString *)inviteLink {
    _inviteLink = inviteLink;
    [[NSUserDefaults standardUserDefaults] setObject:inviteLink forKey:kInviteLink];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
