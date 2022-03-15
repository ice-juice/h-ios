//
//  ContractTableHeaderView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractTableHeaderView : BaseView
//选择持仓、委托
@property (nonatomic, copy) void (^onBtnWithSelectCurrentBlock)(NSInteger index);
//平仓记录
@property (nonatomic, copy) void (^onBtnWithCheckCloseRecordsBlock)(void);
//选择市价、限价
@property (nonatomic, copy) void (^onBtnWithSelectPriceBlock)(NSInteger index);
//选择显示全部或当前合约
@property (nonatomic, copy) void (^onBtnWithSelectAllOrCurrentBlock)(NSInteger index);
//下单
@property (nonatomic, copy) void (^onSubmitOrderBlock)(NSString *unit, NSString *numbers, NSString *compactType, NSString *leverageId);
//一键平仓、全部撤销
@property (nonatomic, copy) void (^onBtnCloseingOrCancelContractBlock)(void);

@property (nonatomic, strong) UIButton *btnPingCang;//一键平仓、全部撤销

//合约页面信息
- (void)setViewWithModel:(id)model;
//当前币种行情数据
- (void)setViewQuotesWithModel:(id)model;
//币种交易信息
- (void)setViewQuotesDealInfoWithModel:(id)model;
- (void)timeAction;
- (void)updateView;

@end

NS_ASSUME_NONNULL_END
