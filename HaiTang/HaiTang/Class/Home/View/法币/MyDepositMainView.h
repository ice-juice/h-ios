//
//  MyDepositMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MyDepositMainViewDelegate <BaseMainViewDelegate>
//退还押金
- (void)onRefundDeposit;
//补缴保证金
- (void)onPayBack;
//确认补缴
- (void)onSubmitPayBackWithPassword:(NSString *)password;
//忘记资金密码
- (void)onForgetPassword;

@end

@interface MyDepositMainView : BaseMainView

@end

NS_ASSUME_NONNULL_END
