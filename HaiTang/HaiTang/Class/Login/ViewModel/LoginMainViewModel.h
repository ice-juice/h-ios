//
//  LoginMainViewModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class ProtocolModel, PhoneCodeModel;

@interface LoginMainViewModel : BaseMainViewModel
{
    dispatch_source_t _timer;
}
//协议类型 SERVER_INFO服务条款 PRIMARY隐私政策
@property (nonatomic, copy) NSString *protocolType;
//账号
@property (nonatomic, copy) NSString *account;
//密码
@property (nonatomic, copy) NSString *password;
//邀请码
@property (nonatomic, copy) NSString *inviteCode;
//手机区号
@property (nonatomic, copy) NSString *phoneCode;

@property (nonatomic, strong) ProtocolModel *protocolModel;

@property (nonatomic, strong) NSArray<PhoneCodeModel *> *arrayPhoneCodeDatas;

- (instancetype)initWithProtocolType:(NSString *)protocolType;

//服务条款、隐私政策
- (void)fetchProtocolWithResult:(RequestResult)result;
//获取验证码
- (void)sendVerifyCodeCountDown:(void(^)(NSString *countDown, BOOL isEnd))block result:(RequestResult)result;
//停止倒计时
- (void)stopCountDown;
//注册
- (void)fetchRegisterWith:(NSString *)verifyCode result:(RequestResult)result;
//登录
- (void)fetchLoginWith:(NSString *)account password:(NSString *)password result:(RequestResult)result;
//忘记密码
- (void)fetchUpdatePassword:(NSString *)account verifyCode:(NSString *)verifyCode result:(RequestResult)result;
//获取手机区号
- (void)fetchPhoneCodeWithResult:(RequestResult)result;
//获取用户信息
- (void)fetchUserInfoWithResult:(RequestResult)result;

@end

NS_ASSUME_NONNULL_END
