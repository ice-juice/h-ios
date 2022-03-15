//
//  FiatMainViewModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class FiatOrderDetailTableModel, BaseTableModel, OrderModel, PaymentMethodModel, AcceptorModel;

@interface FiatMainViewModel : BaseMainViewModel
{
    dispatch_source_t _timer;
}
//订单状态
@property (nonatomic, assign) FiatOrderStatus orderStatus;
//保证金状态
@property (nonatomic, assign) MyDepositStatus depositStatus;
//订单类型(0-购买订单 1-出售订单)
@property (nonatomic, assign) NSInteger orderType;
//支付方式 ALI_PAY(支付宝) WE_CHAT(微信) BANK(银行卡) PALPAL(默认空)
@property (nonatomic, copy) NSString *payMethod;
//金额
@property (nonatomic, copy) NSString *price;
//数量
@property (nonatomic, copy) NSString *number;
//购买方式 0-数量 1-金额
@property (nonatomic, copy) NSString *buyMethod;
//下单购买订单号
@property (nonatomic, copy) NSString *orderNo;
//申诉内容
@property (nonatomic, copy) NSString *content;
//图片地址
@property (nonatomic, copy) NSString *imgUrls;
//订单id
@property (nonatomic, copy) NSString *sellId;
//订单id
@property (nonatomic, copy) NSString *buyId;
//收款方式id
@property (nonatomic, copy) NSString *paymentId;
//交易密码
@property (nonatomic, copy) NSString *payPwd;
//最小数量
@property (nonatomic, copy) NSString *lowNumber;
//最小金额
@property (nonatomic, copy) NSString *lowPrice;
//下单购买、出售值
@property (nonatomic, copy) NSString *value;
//BUY-购买订单 SELL-出售订单
@property (nonatomic, copy) NSString *pageType;

//订单详情
@property (nonatomic, strong) OrderModel *orderDetailModel;
//收款方式
@property (nonatomic, strong) PaymentMethodModel *paymentMethodModel;
//承兑商保证金
@property (nonatomic, strong) AcceptorModel *acceptorModel;
//订单详情
@property (nonatomic, strong) NSMutableArray<FiatOrderDetailTableModel *> *arrayOrderDetailDatas;
//承兑商
@property (nonatomic, strong) NSMutableArray<BaseTableModel *> *arrayAcceptorTableDatas;
//收款方式
@property (nonatomic, strong) NSMutableArray<BaseTableModel *> *arrayPaymentTableDatas;
//法币交易（我要购买、我要出售）列表
@property (nonatomic, strong) NSMutableArray<OrderModel *> *arrayOrderListDatas;
//我的订单列表
@property (nonatomic, strong) NSMutableArray<OrderModel *> *arrayMineOrderListDatas;
//上传凭证
@property (nonatomic, strong) NSMutableArray<NSString *> *arrayImageUrls;
//收款方式
@property (nonatomic, strong) NSMutableArray<BaseTableModel *> *arrayPaymentMethodDatas;

@property (nonatomic, copy) void(^onUpdatePayCountDownBlock)(NSString *timeString, BOOL isEnd); // 刷新付款倒计时

- (instancetype)initWithOrderType:(NSInteger)orderType;
- (instancetype)initWithDepositStatus:(MyDepositStatus)depositStatus;
- (instancetype)initWithOrderNo:(NSString *)orderNo;
- (instancetype)initWithOrderNo:(NSString *)orderNo pageType:(NSString *)pageType;
- (instancetype)initWithOrderDetailModel:(OrderModel *)orderDetailModel;
- (instancetype)initWithAcceptorModel:(AcceptorModel *)acceptorModel;
- (instancetype)initWithOrderStatus:(FiatOrderStatus)orderStatus orderType:(NSInteger)orderType;

- (void)loadOrderDetailTableDatas;
- (void)loadAcceptorTableDatas;
- (void)loadPaymentMethodTableDatas;
// 停止倒计时
- (void)stopCountDown;

//法币交易（我要购买、我要出售）列表
- (void)fetchOrderListWithResult:(RequestMoreResult)result;
//下单购买
- (void)fetchOrderBuyWithResult:(RequestResult)result;
//下单出售
- (void)fetchOrderSellWithResult:(RequestResult)result;
//法币交易-订单页面信息
- (void)fetchOrderInfoWithResult:(RequestResult)result;
//待付款页面-取消订单前调用（获取提示信息）
- (void)fetchOrderCancelTipWithResult:(RequestMsgResult)result;
//取消订单
- (void)fetchOrderCancelWithResult:(RequestResult)result;
//我的订单
- (void)fetchMineOrderListWithResult:(RequestMoreResult)result;
//待付款页面-已完成付款
- (void)fetchOrderFinishPayWithResult:(RequestResult)result;
//上传图片
- (void)fetchUploadImage:(UIImage *)img result:(RequestResult)result;
//申诉
- (void)fetchSubmitAppealWithResult:(RequestResult)result;
//承兑商页面保证金情况
- (void)fetchAcceptorMarginInfoWithResult:(RequestResult)result;
//申请承兑商
- (void)fetchApplyToBecomeAnAcceptorWithResult:(RequestResult)result;
//挂单购买
- (void)fetchPendingOrderPurchaseWithResult:(RequestResult)result;
//我的订单（挂单购买、挂单出售订单）
- (void)fetchMinePendingOrderListWithResult:(RequestMoreResult)result;
//撤单
- (void)fetchCancelPendingOrderWithResult:(RequestResult)result;
//挂单出售页面信息
- (void)fetchPendingOrderSellInfoWithResult:(RequestResult)result;
//挂单出售
- (void)fetchPendingOrderSellWithResult:(RequestResult)result;
//退还保证金
- (void)fetchRefundDepositWithResult:(RequestResult)result;
//放币
- (void)fetchPutMoneyWithPassword:(NSString *)password result:(RequestResult)result;
//补缴押金页面信息
- (void)fetchMakeUpDepositWithResult:(RequestResult)result;
//提交补缴
- (void)fetchSubmitDepositWithPassword:(NSString *)password result:(RequestResult)result;

@end

NS_ASSUME_NONNULL_END
