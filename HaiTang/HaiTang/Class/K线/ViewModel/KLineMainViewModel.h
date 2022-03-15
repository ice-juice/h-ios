//
//  KLineMainViewModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QuotesModel, Y_KLineGroupModel, TradeListModel,  TradeListSubModel;

@interface KLineMainViewModel : BaseMainViewModel
//类型 币币-0 永续合约-1
@property (nonatomic, copy) NSString *type;
//币种
@property (nonatomic, copy) NSString *symbol;

//当前币种行情
@property (nonatomic, strong) QuotesModel *currentQuotesModel;
//某个币种的k线图数据
@property (nonatomic, strong) Y_KLineGroupModel *kLineGroupModel;
//币种交易信息
@property (nonatomic, strong) TradeListModel *tradeListModel;
//合约简介
@property (nonatomic, strong) TradeListSubModel *introductionModel;
//所有币种行情
@property (nonatomic, strong) NSMutableArray<QuotesModel *> *arrayQuotesDatas;
//合约最新成交价
@property (nonatomic, strong) NSMutableArray<TradeListSubModel *> *arrayNewPriceDatas;

- (instancetype)initWithSymbol:(NSString *)symbol;
- (instancetype)initWithSymbol:(NSString *)symbol type:(NSString *)type;

//获取币种行情
- (void)fetchSymbolQuotesWithResult:(RequestResult)result;
//合约简介
- (void)fetchContractIntroductionWithResult:(RequestResult)result;
//盘口深度
- (void)fetchCurrencyDealInfoWithResult:(RequestResult)result;
//合约最新成交价
- (void)fetchContractNewPriceWithResult:(RequestResult)result;

@end

NS_ASSUME_NONNULL_END
