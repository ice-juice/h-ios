//
//  WithdrawPopupView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawPopupView : BaseView
- (void)showView;
- (void)closeView;

@property (nonatomic, copy) NSString *imgName0;
@property (nonatomic, copy) NSString *imgName1;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^onGoSafetyBlock)(void);

@end

NS_ASSUME_NONNULL_END
