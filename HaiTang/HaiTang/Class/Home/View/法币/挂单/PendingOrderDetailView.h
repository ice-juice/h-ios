//
//  PendingOrderDetailView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PendingOrderDetailViewDelegate <BaseMainViewDelegate>
//撤单
- (void)cancelOrder;

@end

@interface PendingOrderDetailView : BaseMainView

@end

NS_ASSUME_NONNULL_END
