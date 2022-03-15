//
//  LoginMainViewModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "LoginMainViewModel.h"
#import "Service.h"
#import "UserModel.h"
#import "ProtocolModel.h"
#import "PhoneCodeModel.h"
#import "UserInfoManager.h"

@implementation LoginMainViewModel
#pragma mark - Life Cycle
- (instancetype)initWithProtocolType:(NSString *)protocolType {
    self = [super init];
    if (self) {
        _protocolType = protocolType;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _phoneCode = @"86";
    }
    return self;
}

#pragma mark - Request
- (void)fetchProtocolWithResult:(RequestResult)result {
    if ([self.protocolType isEqualToString:@"white"]) {
        //白皮书
        [Service fetchWhiteBookWithParams:nil mapper:[ProtocolModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
            if (responseModel.data) {
                self.protocolModel = responseModel.data;
                result(YES);
            }
        } failure:^(NSError * _Nonnull error) {
            Logger(@"获取白皮书详情失败");
            result(NO);
        }];
    } else {
        NSDictionary *params = @{@"type" : self.protocolType};
        [Service fetchProtocolWithParams:params mapper:[ProtocolModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
            if (responseModel.data) {
                self.protocolModel = responseModel.data;
                result(YES);
            }
        } failure:^(NSError * _Nonnull error) {
            Logger(@"获取服务条款、隐私政策失败");
            result(NO);
        }];
    }
}

- (void)sendVerifyCodeCountDown:(void (^)(NSString * _Nonnull, BOOL))block result:(RequestResult)result {
    if ([NSString isEmpty:self.account]) {
        return;
    }
    NSDictionary *params = @{@"account" : self.account,
                             @"code" : self.phoneCode
    };
    [Service sendVerifyCodeWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            [self startCountDownWithBlock:block];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取验证码失败");
        result(NO);
    }];
}

- (void)fetchRegisterWith:(NSString *)verifyCode result:(RequestResult)result {
    if ([NSString isEmpty:self.account]) {
        return;
    }
    NSDictionary *params = @{@"account" : self.account,
                             @"password" : self.password,
                             @"inviteCode" : self.inviteCode,
                             @"msg" : verifyCode,
                             @"code" : self.phoneCode
    };
    [Service fetchRegisterWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"注册失败");
        result(NO);
    }];
}

- (void)fetchLoginWith:(NSString *)account password:(NSString *)password result:(RequestResult)result {
    NSDictionary *params = @{@"account" : account,
                             @"password" : password
    };
    [Service fetchLoginWithParams:params mapper:[UserModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            UserModel *userModel = responseModel.data;
            [[NSUserDefaults standardUserDefaults] setObject:userModel.token forKey:kToken];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"登录失败");
        result(NO);
    }];
}

- (void)fetchUserInfoWithResult:(RequestResult)result {
    [Service fetchUserInfoWithParams:nil mapper:[UserModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            [[UserInfoManager sharedManager] setUserInfo:responseModel.data];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取用户信息失败");
        result(NO);
    }];
}

- (void)fetchUpdatePassword:(NSString *)account verifyCode:(NSString *)verifyCode result:(RequestResult)result {
    NSDictionary *params = @{@"account" : account,
                             @"password" : self.password,
                             @"confirmPwd" : self.password,
                             @"msg" : verifyCode
    };
    [Service fetchUpdatePasswordWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"修改密码失败");
        result(NO);
    }];
}

- (void)fetchPhoneCodeWithResult:(RequestResult)result {
    [Service fetchPhoneCodeWithParams:nil mapper:[PhoneCodeModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.arrayPhoneCodeDatas = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取手机区号失败");
        result(NO);
    }];
}

#pragma mark - PrivateMethod
- (void)startCountDownWithBlock:(void (^)(NSString * _Nonnull, BOOL))block {
    
    int countdownSecond = [self.account containsString:@"@"] ? kEmailCountdownSecond : kCountdownSecond;
    
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        
        NSTimeInterval countdownTime = currentTime - startTime;
        
        NSInteger retainTime = countdownSecond - countdownTime;
        if (retainTime > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    block([NSString stringWithFormat:@"%02lds", retainTime], NO);
                }
            });
            
        } else {
            //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    block([NSString stringWithFormat:NSLocalizedString(@"重新发送", nil)], YES);
                }
            });
        }
        
    });
    dispatch_resume(_timer);
}

- (void)stopCountDown {
    //停止倒计时
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

@end
