//
//  SymbolModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LeverageListModel;

@interface SymbolModel : BaseModel
@property (nonatomic, copy) NSString *symbols;   //币种

/**
 合约页面信息
 symbols
 */
@property (nonatomic, copy) NSString *handNumber;                            //一手价值
@property (nonatomic, strong) NSArray<LeverageListModel *> *leverageList;    //全仓杠杆倍率记录
@property (nonatomic, copy) NSString *price;                                 //可用余额
@property (nonatomic, copy) NSString *openFeePrice;                          //开仓手续费率，需要除以100
@property (nonatomic, assign) CGFloat headerHeight;                          //合约页面头部高度

/**
 币币交易页面信息
 price 可用数量
 */
@property (nonatomic, copy) NSString *feeRate;                               //手续费比例
//交易类型 BUY-买入 SELL-卖出
@property (nonatomic, copy) NSString *matchType;
//最小委托量
@property (nonatomic, copy) NSString *minBuyNumber;

@end

NS_ASSUME_NONNULL_END
