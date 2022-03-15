//
//  BindMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BindMainViewDelegate <BaseMainViewDelegate>
//获取第一次验证码
- (void)mainViewWithSendVerifyCode;
//验证第一次验证码
- (void)mainViewWithVerificationCode:(NSString *)verifyCode;
//绑定邮箱或手机
- (void)mainViewWithBinding:(NSString *)verifyCode;
//选择区号
- (void)selectPhoneCode;

@end

@interface BindMainView : BaseMainView
// 刷新倒计时
- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd;
//检验验证码是否正确
- (void)updateVerifyCodeResult;
@property (nonatomic, strong) UIButton *btnAreaCode;

@end

NS_ASSUME_NONNULL_END
