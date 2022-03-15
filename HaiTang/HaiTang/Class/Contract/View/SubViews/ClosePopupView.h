//
//  ClosePopupView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClosePopupView : BaseView
- (void)showView;
- (void)closeView;
- (void)setViewWithModel:(id)model;
- (void)calculationProfitAndLoss;

//平仓
@property (nonatomic, copy) void (^onBtnCloseingBlock)(NSString *compactId, NSString *number);
//平仓价格
@property (nonatomic, strong) UILabel *lbClosePrice;

@end

NS_ASSUME_NONNULL_END
