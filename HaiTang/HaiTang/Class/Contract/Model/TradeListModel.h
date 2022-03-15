//
//  TradeListModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/26.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeListModel : BaseModel
//卖单 数组第一个是价格 第二个是数量
@property (nonatomic, strong) NSArray *asks;
//买单 数组第一个是价格 第二个是数量
@property (nonatomic, strong) NSArray *bids;

@property (nonatomic, copy) NSString *number;

@end

NS_ASSUME_NONNULL_END
