//
//  WithdrawMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WithdrawMainViewDelegate <BaseMainViewDelegate>
//选择币种
- (void)mainViewWithSelectSymbol;
//获取验证码
- (void)mainViewWithSendVerifyCode;
//提币
- (void)mainViewWithSubmitWithdraw;
//忘记密码
- (void)forgetAssetsPassword;
//前往安全设置
- (void)goSafety;
//扫一扫
- (void)scanAddress;

@end

@interface WithdrawMainView : BaseMainView
// 刷新倒计时
- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd;

@property (nonatomic, strong) UITextField *tfAddress;   //提币地址

@end

NS_ASSUME_NONNULL_END
