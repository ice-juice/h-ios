//
//  CoinTableHeaderView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinTableHeaderView : BaseView
//成交记录
@property (nonatomic, copy) void (^onBtnWithCheckDealRecordBlock)(void);
//交易类型
@property (nonatomic, copy) void (^onDidSelectMatchTypeBlock)(NSString *matchType);
//交易方式
@property (nonatomic, copy) void (^onDidSelectDealWayBlock)(NSString *dealWay);
//交易
@property (nonatomic, copy) void (^onBtnWithSubmitDealBlock)(NSString *price, NSString *number);
//交易对
@property (nonatomic, copy) NSString *symbols;

//币币页面信息
- (void)setViewWithModel:(id)model;
//当前币种行情数据
- (void)setViewQuotesWithModel:(id)model;
//币种交易信息
- (void)setViewQuotesDealInfoWithModel:(id)model;
//获取数据
- (void)timeAction;
//刷新页面
- (void)updateView;

@end

NS_ASSUME_NONNULL_END
