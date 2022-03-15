//
//  FilterPurchaseView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterPurchaseView : BaseView
- (void)showView;
- (void)closeView;

@property (nonatomic, copy) void (^onBtnWithFilterBlock)(NSString *payment, NSString *price, NSString *number);

@end

NS_ASSUME_NONNULL_END
