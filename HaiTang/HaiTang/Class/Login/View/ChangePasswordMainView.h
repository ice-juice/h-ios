//
//  ChangePasswordMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChangePasswordMainViewDelegate <BaseMainViewDelegate>
//修改密码
- (void)mainViewWithUpdatePassword;

@end

@interface ChangePasswordMainView : BaseMainView

@end

NS_ASSUME_NONNULL_END
