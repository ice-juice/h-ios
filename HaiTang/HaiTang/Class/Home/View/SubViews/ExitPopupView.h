//  退出登录
//  ExitPopupView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExitPopupView : BaseView
- (void)showView;
- (void)closeView;

//退出登录
@property (nonatomic, copy) void (^onBtnWithLogoutBlock)(void);

@end

NS_ASSUME_NONNULL_END
