//
//  ForgetPasswordMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ForgetPasswordMainViewDelegate <BaseMainViewDelegate>
//获取验证码
- (void)mainViewWithSendVerifyCode;
//下一步
- (void)mainViewWithNext:(NSString *)verifyCode;

@end

@interface ForgetPasswordMainView : BaseMainView
// 刷新倒计时
- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd;

@end

NS_ASSUME_NONNULL_END
