//
//  PendingOrderBuyMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PendingOrderBuyMainViewDelegate <BaseMainViewDelegate>
//提交下单
- (void)submitOrder;

@end

@interface PendingOrderBuyMainView : BaseMainView

@end

NS_ASSUME_NONNULL_END
