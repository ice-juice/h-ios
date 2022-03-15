//
//  ContractMainViewModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RecordSubModel, SymbolModel, RecordSubModel, QuotesModel, TradeListModel;

@interface ContractMainViewModel : BaseMainViewModel
//记录类别 0-平仓记录 1-成交记录
@property (nonatomic, assign) RecordType recordType;

//币种(全部币种传空)
@property (nonatomic, copy) NSString *symbols;
//类型（全部类型传空）
@property (nonatomic, copy) NSString *flowType;
//合约页面类型(N-持仓 IN-当前委托 Y-历史订单)(默认持仓)
@property (nonatomic, copy) NSString *contract_type;
//持仓或当前委托需要传递显示的数据：All-显示全部(默认) CURRENT-显示当前合约、委托
@property (nonatomic, copy) NSString *showMethod;
//交易价格
@property (nonatomic, copy) NSString *unitPrice;
//交易数量
@property (nonatomic, copy) NSString *numbers;
//类型 BUY-买入做多 SELL-卖出做空
@property (nonatomic, copy) NSString *compactType;
//交易方式
@property (nonatomic, copy) NSString *dealWay;
//杠杆倍率
@property (nonatomic, copy) NSString *leverageId;
//平仓id(一键平仓为空)
@property (nonatomic, copy) NSString *compactId;
//平仓类型(1:平仓某个订单 2:一键平仓) 撤销类型 (1:撤销某一条 2:一键撤销)
@property (nonatomic, copy) NSString *operationType;
//平仓状态 手动平仓：HANDLE 强制平仓：FIXED 止盈平仓：PROFIT 止损平仓：LOSS
@property (nonatomic, copy) NSString *closeingStatus;

//合约页面信息
@property (nonatomic, strong) SymbolModel *contractInfoModel;
//币种交易信息
@property (nonatomic, strong) TradeListModel *tradeListModel;
//当前币种行情数据
@property (nonatomic, strong) QuotesModel *currentQuotesModel;

//全部币种
@property (nonatomic, strong) NSArray<SymbolModel *> *arraySymbolDatas;
//流水类型
@property (nonatomic, strong) NSArray<RecordSubModel *> *arrayRecordTypeDatas;
//币种行情
@property (nonatomic, strong) NSArray<QuotesModel *> *arrayQuotesDatas;
//流水记录
@property (nonatomic, strong) NSMutableArray<RecordSubModel *> *arrayRecordDatas;
//合约订单列表
@property (nonatomic, strong) NSMutableArray<RecordSubModel *> *arrayContractOrderDatas;

- (instancetype)initWithRecordType:(RecordType)recordType symbols:(NSString *)symbols;

//流水记录
- (void)fetchRecordsWithResult:(RequestMoreResult)result;
//类型
- (void)fetchTypeWithResult:(RequestResult)result;
//充币、提币记录
- (void)fetchRechargeOrWithdrawRecordWithResult:(RequestMoreResult)result;
//合约页面信息及币种列表
- (void)fetchContractInfoWithResult:(RequestResult)result;
//合约订单列表
- (void)fetchContractOrderListWithResult:(RequestMoreResult)result;
//币种行情
- (void)fetchContractMarketWithResult:(RequestResult)result;
//合约交易
- (void)fetchSubmitContractWithResult:(RequestResult)result;
//平仓
- (void)fetchCloseingWithResult:(RequestResult)result;
//撤销
- (void)fetchCancelContractWithResult:(RequestResult)result;
//止盈止损
- (void)fetchTakeProfit:(NSString *)profitPrice stopLoss:(NSString *)lossPrice result:(RequestResult)result;
//平仓记录
- (void)fetchCloseingRecordsWithResult:(RequestMoreResult)result;
//成交记录
- (void)fetchCurrencyRecordsWithResult:(RequestMoreResult)result;

@end

NS_ASSUME_NONNULL_END
