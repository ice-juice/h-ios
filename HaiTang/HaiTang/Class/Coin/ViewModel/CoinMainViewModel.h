//
//  CoinMainViewModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SymbolModel, QuotesModel, TradeListModel, RecordSubModel;

@interface CoinMainViewModel : BaseMainViewModel
//交易对(默认BTC/USDT)
@property (nonatomic, copy) NSString *type;
//交易类型 BUY-买入 SELL-卖出（默认买入）
@property (nonatomic, copy) NSString *matchType;
//交易方式 MARKET-市价 LIMIT-限价 交易方式（默认市价）
@property (nonatomic, copy) NSString *dealWay;
@property (nonatomic, copy) NSString *compactId;

//币币交易页面信息
@property (nonatomic, strong) SymbolModel *coinInfoModel;
//当前行情model
@property (nonatomic, strong) QuotesModel *currentQuotesModel;
//币种交易信息
@property (nonatomic, strong) TradeListModel *tradeListModel;

//所有币种行情
@property (nonatomic, strong) NSArray<QuotesModel *> *arrayQuotesDatas;
//币币委托、记录
@property (nonatomic, strong) NSMutableArray<RecordSubModel *> *arrayCommOrRecordDatas;

//币币交易页面信息
- (void)fetchCoinInfoWithResult:(RequestResult)result;
//币币行情
- (void)fetchQuotesWithResult:(RequestResult)result;
//当前委托
- (void)fetchCommissionWithResult:(RequestMoreResult)result;
//交易
- (void)fetchSubmitDealWithPrice:(NSString *)price number:(NSString *)number result:(RequestResult)result;
//撤销委托
- (void)fetchRevocationCommissionWithResult:(RequestResult)result;

@end

NS_ASSUME_NONNULL_END
