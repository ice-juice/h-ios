//
//  RegisterMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RegisterMainViewDelegate <BaseMainViewDelegate>
//服务条款、隐私政策
- (void)mainViewWithCheckProtocol:(NSString *)protocolType;
//登录
- (void)mainViewWithLogin;
//获取验证码
- (void)mainViewWithSendVerifyCode;
//注册
- (void)mainViewWithRegister:(NSString *)verifyCode;
//选择区号
- (void)selectPhoneCode;

@end

@interface RegisterMainView : BaseMainView
// 刷新倒计时
- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd;

@property (nonatomic, strong) UIButton *btnAreaCode;

@end

NS_ASSUME_NONNULL_END
