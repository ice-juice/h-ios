//
//  EnterFundPasswordView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnterFundPasswordView : BaseView
- (void)showViewWithTitle:(NSString *)title;
- (void)closeView;

@property (nonatomic, copy) void (^onBtnSubmitPasswordBlock)(NSString *password);
//忘记密码
@property (nonatomic, copy) void (^onBtnForgetPasswordBlock)(void);

@end

NS_ASSUME_NONNULL_END
