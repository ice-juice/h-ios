//
//  RechargeCollectionCell.h
//  HaiTang
//
//  Created by 吴紫颖 on 2021/2/4.
//  Copyright © 2021 zy. All rights reserved.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeCollectionCell : BaseCollectionViewCell

@property (nonatomic, copy) void (^onDeleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
