//
//  SafetyVerificationView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SafetyVerificationView : BaseView
// 刷新倒计时
- (void)updateCountDown:(NSString *)countDown isEnd:(BOOL)isEnd;
- (void)showViewWithVerifyCodeType:(VerifyCodeType)verifyCodeType;
- (void)changeViewWithVerifyCodeType:(VerifyCodeType)verifyCodeType;
- (void)closeView;

@property (nonatomic, assign) VerifyCodeType verifyCodeType;
//获取验证码
@property (nonatomic, copy) void (^onBtnWithSendVerifyCodeBlock)(void);
//提交
@property (nonatomic, copy) void (^onBtnWithSubmitRegisterBlock)(NSString *verifyCode);
//关闭视图
@property (nonatomic, copy) void (^onBtnWithCloseViewBlock)(void);

@end

NS_ASSUME_NONNULL_END
