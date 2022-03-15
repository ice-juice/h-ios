//
//  LoginMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/9.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LoginMainViewDelegate <BaseMainViewDelegate>
//注册
- (void)mainViewWithRegister;
//忘记密码
- (void)mainViewWithForgetPassword;
//登录
- (void)mainViewWithLogin:(NSString *)account password:(NSString *)password;

@end

@interface LoginMainView : BaseMainView

@end

NS_ASSUME_NONNULL_END
