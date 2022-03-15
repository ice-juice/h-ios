//
//  AuthenticationMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AuthenticationMainViewDelegate <BaseMainViewDelegate>
//下一步
//- (void)mainViewWithType:(NSString *)type withAccount:(NSString *)account withXing:(NSString *)xing withMing:(NSString *)ming;
//下一步
- (void)mainViewWithNext;

@end

@interface AuthenticationMainView : BaseMainView

@end

NS_ASSUME_NONNULL_END
