//
//  UserInfoManager.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

@interface UserInfoManager : NSObject
+ (UserInfoManager *)sharedManager;
- (UserInfoManager *)getUserInfo;
- (void)setUserInfo:(UserModel *)userModel;
- (void)clearUserInfo;

@property (nonatomic, copy) NSString *account;       //账号
@property (nonatomic, copy) NSString *email;         //邮箱
@property (nonatomic, copy) NSString *phone;         //电话
@property (nonatomic, copy) NSString *realStatus;    //是否实名认证 0:未认证 1:已认证 2:审核中
@property (nonatomic, copy) NSString *inviteCode;    //邀请码
@property (nonatomic, copy) NSString *inviteLink;    //邀请链接
@property (nonatomic, copy) NSString *isOpenPay;     //是否开启资产密码 Y-是 N-否
@property (nonatomic, copy) NSString *paySmsType;    //资产密码验证方式 PHONE-手机验证 EMAIL邮箱验证,通过账号进行发送短信或邮箱验证码
@property (nonatomic, copy) NSString *nickName;      //昵称
@property (nonatomic, copy) NSString *realName;      //真实姓名，用于法币收款方式设置那里显示
@property (nonatomic, copy) NSString *loginMethod;   //登录方式 PHONE-手机


@end

NS_ASSUME_NONNULL_END
