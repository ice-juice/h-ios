//
//  PendingOrderSellMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PendingOrderSellMainViewDelegate <BaseMainViewDelegate>
//绑定收款方式
- (void)addPaymentWithIndexPath:(NSIndexPath *)indexPath;
//挂单出售
- (void)submitPendingOrderSell;

@end

@interface PendingOrderSellMainView : BaseMainView

@end

NS_ASSUME_NONNULL_END
