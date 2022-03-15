//
//  Service.h
//  GoldenHShield
//
//  Created by 吴紫颖 on 2020/4/30.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Service : NSObject
/** 手机区号 */
+ (void)fetchPhoneCodeWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 服务条款、隐私政策 */
+ (void)fetchProtocolWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 获取验证码 */
+ (void)sendVerifyCodeWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 注册 */
+ (void)fetchRegisterWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 登录 */
+ (void)fetchLoginWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 忘记密码 */
+ (void)fetchUpdatePasswordWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 平台公告列表 */
+ (void)fetchNewsListWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 轮播图列表 */
+ (void)fetchBannerListWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 帮助中心 */
+ (void)fetchHelpListWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 用户信息 */
+ (void)fetchUserInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 修改登录密码或资产密码 */
+ (void)fetchUpdateNewPasswordWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 设置昵称 */
+ (void)fetchNickNameWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 检验验证码是否正确 */
+ (void)fetchVerificationCodeWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 账号绑定 */
+ (void)fetchBindingAccountWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 退出登录 */
+ (void)fetchLogoutWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 收款方式列表 */
+ (void)fetchCollectionSettingsWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 上传图片文件 */
+ (void)uploadImageWithParams:(nullable NSDictionary *)params imageArray:(NSArray *)imageArray mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 实名认证 */
+ (void)fetchRealNameVerifyWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 添加收款方式 */
+ (void)fetchAddPaymentWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 删除收款方式 */
+ (void)fetchDeletePaymentWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 个人资产信息 */
+ (void)fetchAssetsInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 资产详情 */
+ (void)fetchAssetsDetailWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 流水记录 */
+ (void)fetchRecordsWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 全部币种 */
+ (void)fetchSymbolListWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 流水类型数据 */
+ (void)fetchRecordTypeWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 充币地址 */
+ (void)fetchRechargeAddressWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 充币提币记录 */
+ (void)fetchRechargeOrWithdrawRecordWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 提币页面信息 */
+ (void)fetchWithdrawInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 提币 */
+ (void)fetchSubmitWithdrawWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 资产划转页面信息 */
+ (void)fetchTransferInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 资产划转 */
+ (void)fetchSubmitTransferWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 合约页面信息 */
+ (void)fetchContractInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 币种行情 */
+ (void)fetchCurrencyQuotesWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 币种交易信息 */
+ (void)fetchCurrencyDealInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 合约订单列表 */
+ (void)fetchContractOrderListWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 币币交易页面信息 */
+ (void)fetchCoinInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 币币委托、记录 */
+ (void)fetchCoinCommissionOrRecordsWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 币币交易 */
+ (void)fetchSubmitCoinDealWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 撤销币币交易委托单 */
+ (void)fetchRevocationCommissionWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 法币交易（我要购买、我要出售）列表 */
+ (void)fetchFiatOrderListWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 下单购买 */
+ (void)fetchFiatOrderBuyWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 法币交易-订单页面信息 */
+ (void)fetchFiatOrderInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 待付款页面-取消订单前调用（获取提示信息） */
+ (void)fetchFiatOrderCancelTipWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 待付款页面-取消订单 */
+ (void)fetchFiatOrderCancelWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 我的订单-（购买订单、出售订单） */
+ (void)fetchMineOrderListWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 待付款页面-已完成付款 */
+ (void)fetchOrderFinishPayWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 申诉 */
+ (void)fetchSubmitAppealWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 挂单买卖-挂单出售-收款方式 */
+ (void)fetchPaymentMethodWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 下单出售 */
+ (void)fetchOrderSellWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 承兑商页面保证金信息情况 */
+ (void)fetchAcceptorMarginInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 申请成为承兑商 */
+ (void)fetchApplyToBecomeAnAcceptorWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 挂单购买 */
+ (void)fetchPendingOrderPurchaseWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 我的订单（挂单购买、出售订单） */
+ (void)fetchMinePendingOrderListWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 挂单中-撤单 */
+ (void)fetchMinePendingOrderCancelWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 挂单出售页面信息 */
+ (void)fetchMinePendingOrderSellInfoWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 挂单出售 */
+ (void)fetchPendingOrderSellWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 退还保证金 */
+ (void)fetchRefundDepositWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 合约交易 */
+ (void)fetchSubmitContractWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 平仓 */
+ (void)fetchCloseingWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 撤销合约委托 */
+ (void)fetchCancelContractWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 止盈止损 */
+ (void)fetchTabkeProfitAndStopLossWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 获取某个币种的k线图数据 */
+ (void)fetchKLineWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 合约最新成交价 */
+ (void)fetchContractNewPriceWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 合约简介 */
+ (void)fetchContractIntroductionWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 联系客服 */
+ (void)fetchServiceWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 强制更新 */
+ (void)fetchUpdateAppVersionWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 放币 */
+ (void)fetchPutMoneyWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 补缴押金页面信息 */
+ (void)fetchMakeUpDepositWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 提交补缴 */
+ (void)fetchSubmitDepositWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 提交充币 */
+ (void)fetchSubmitRechargeWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 白皮书详情 */
+ (void)fetchWhiteBookWithParams:(nullable NSDictionary *)params mapper:(nullable id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
