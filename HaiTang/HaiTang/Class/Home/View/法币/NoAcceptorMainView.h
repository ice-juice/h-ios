//
//  NoAcceptorMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NoAcceptorMainViewDelegate <BaseMainViewDelegate>
//申请成为承兑商
- (void)applyToBecomeAnAcceptor;
//忘记资产密码
- (void)onForgetAssetsPassword;

@end

@interface NoAcceptorMainView : BaseMainView

@end

NS_ASSUME_NONNULL_END
