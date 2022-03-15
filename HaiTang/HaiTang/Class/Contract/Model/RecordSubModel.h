//
//  RecordSubModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordSubModel : BaseModel
@property (nonatomic, copy) NSString *createTime;        //时间
@property (nonatomic, copy) NSString *createTimeStamp;   //时间戳
@property (nonatomic, copy) NSString *flowCoin;          //币种
@property (nonatomic, copy) NSString *flowPrice;         //流水金额
@property (nonatomic, copy) NSString *flowType;          //流水类型
@property (nonatomic, copy) NSString *name;              //名称
@property (nonatomic, copy) NSString *pageType;          //页面类型
@property (nonatomic, copy) NSString *remark;            //备注（划转流水记录用到改值与名称拼接）
@property (nonatomic, copy) NSString *symbol;            //符号 正负

/**
 流水类型数据
 createTime
 */
@property (nonatomic, copy) NSString *code;              //用于流水类型查询传递
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *sources;           //类型：下拉显示
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updateTime;

/**
 充币、提币记录
 type        类型
 type_id
 remark   提币记录是Memo值或tag值
 */
@property (nonatomic, copy) NSString *coin;              //币种
@property (nonatomic, copy) NSString *price;             //数量
@property (nonatomic, copy) NSString *status;            //状态
@property (nonatomic, copy) NSString *time;              //时间
@property (nonatomic, copy) NSString *timeStamp;         //时间戳
@property (nonatomic, copy) NSString *actualPrice;       //实际金额
@property (nonatomic, copy) NSString *address;           //地址
@property (nonatomic, copy) NSString *fee;               //手续费
@property (nonatomic, copy) NSString *txHash;            //区块链id

/**
合约订单模块
 fee        建仓手续费
 createTime   建仓时间或委托时间
 */
@property (nonatomic, copy) NSString *closeFeePrice;      //平仓手续费
@property (nonatomic, copy) NSString *closeNumber;        //平仓手数
@property (nonatomic, copy) NSString *compactId;
@property (nonatomic, copy) NSString *compactType;        //交易类型（BUY-买入开多 SELL-卖出开多）
@property (nonatomic, copy) NSString *exitPositionPrice;  //平仓保证金
@property (nonatomic, copy) NSString *exitPrice;          //平仓价格
@property (nonatomic, copy) NSString *exitTime;           //平仓时间
@property (nonatomic, copy) NSString *exitType;           //平仓类型
@property (nonatomic, copy) NSString *handPrice;          //平仓价值
@property (nonatomic, copy) NSString *leverName;          //杠杆倍率
@property (nonatomic, copy) NSString *lossProfit;         //盈亏额
@property (nonatomic, copy) NSString *lossProfitRatio;    //盈亏率
@property (nonatomic, copy) NSString *numbers;            //持仓手数或委托手数
@property (nonatomic, copy) NSString *openHandPrice;      //持仓价值
@property (nonatomic, copy) NSString *orderNo;            //订单号
@property (nonatomic, copy) NSString *positionPrice;      //仓位保证金或持仓保证金
@property (nonatomic, copy) NSString *stopLoss;           //止损价
@property (nonatomic, copy) NSString *stopProfit;         //止盈价
@property (nonatomic, copy) NSString *symbols;            //币种
@property (nonatomic, copy) NSString *tradePrice;         //建仓价格、委托价格
@property (nonatomic, copy) NSString *exitFeeRatio;       //平仓手续费率，需要自己除100
@property (nonatomic, copy) NSString *handNumber;         //每手价值
@property (nonatomic, copy) NSString *currentPrice;       //每个币种的当前行情价

/**
 币币委托记录
 createTime   创建时间
 symbols        交易对
 type  1:当前委托   2:买入 3:卖出 空-全部类型
 */
@property (nonatomic, copy) NSString *avgUnit;            //成交均价
@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, copy) NSString *matchType;          //BUY-买入 SELL-卖出
@property (nonatomic, copy) NSString *numberFee;          //手续费
@property (nonatomic, copy) NSString *numbersB;           //成交量
@property (nonatomic, copy) NSString *numbersU;           //成交总额
@property (nonatomic, copy) NSString *unit;                //委托价
@property (nonatomic, copy) NSString *willNumberB;         //委托量

@end

NS_ASSUME_NONNULL_END
