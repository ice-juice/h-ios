//
//  ModifyPasswordMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ModifyPasswordMainViewDelegate <BaseMainViewDelegate>
//修改登录密码或资产密码
- (void)mainViewWithUpdateNewPassword:(NSString *)msgOrOldPassword;
//获取验证码
- (void)mainViewWithSendVerifyCode;
//设置昵称
- (void)mainViewWithSetNickName:(NSString *)nickName;

@end

@interface ModifyPasswordMainView : BaseMainView
// 刷新倒计时
- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd;

@end

NS_ASSUME_NONNULL_END
