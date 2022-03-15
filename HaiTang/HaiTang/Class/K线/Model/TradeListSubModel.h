//
//  TradeListSubModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeListSubModel : BaseModel
@property (nonatomic, copy) NSString *price;      //价格
@property (nonatomic, copy) NSString *number;     //数量
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) NSInteger index;

/**
 合约最新成交价
 price     价格
 */
@property (nonatomic, copy) NSString *amount;      //数量
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *ts;          //时间戳
@property (nonatomic, copy) NSString *direction;   //方向 sell-卖 buy-买

/**
 合约简介
 price    最小变动价格
 */
@property (nonatomic, copy) NSString *handNumber;   //合约大小
@property (nonatomic, copy) NSString *symbol;       //币种


@end

NS_ASSUME_NONNULL_END
