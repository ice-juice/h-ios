//
//  StopLossPopupView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StopLossPopupView : BaseView
- (void)showView;
- (void)closeView;

//止盈止损
@property (nonatomic, copy) void (^onBtnSetTakeProfitAndStopLossBlock)(NSString *profitPrice, NSString *lossPrice);

@end

NS_ASSUME_NONNULL_END
