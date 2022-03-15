//
//  PendingOrderSellTableCell.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class NewModel;

@interface PendingOrderSellTableCell : BaseTableViewCell

@property (nonatomic, assign) BOOL isCellSelected;
 //选中的账号model
@property (nonatomic, strong) NewModel *selectModel;

@property (nonatomic, assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
