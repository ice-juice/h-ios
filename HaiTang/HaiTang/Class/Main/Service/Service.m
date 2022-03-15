//
//  Service.m
//  GoldenHShield
//
//  Created by 吴紫颖 on 2020/4/30.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "Service.h"
#import "HttpManager.h"

@implementation Service
/** 获取手机区号 */
+ (void)fetchPhoneCodeWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/phoneCode" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 服务条款、隐私政策 */
+ (void)fetchProtocolWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/article" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 获取验证码 */
+ (void)sendVerifyCodeWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/getMsg" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 注册 */
+ (void)fetchRegisterWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/register" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 登录 */
+ (void)fetchLoginWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/login" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 忘记密码 */
+ (void)fetchUpdatePasswordWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/forgetPwd" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 平台公告列表 */
+ (void)fetchNewsListWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/newsList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 轮播图列表 */
+ (void)fetchBannerListWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/carousel" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 帮助中心 */
+ (void)fetchHelpListWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/problem" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 用户信息 */
+ (void)fetchUserInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/info" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 修改登录密码或资产密码 */
+ (void)fetchUpdateNewPasswordWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/pwd" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 设置昵称 */
+ (void)fetchNickNameWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/nickName" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 检验验证码是否正确 */
+ (void)fetchVerificationCodeWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/checkSmsCode" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 账号绑定 */
+ (void)fetchBindingAccountWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/bindAccount" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 退出登录 */
+ (void)fetchLogoutWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/logout" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 收款方式列表 */
+ (void)fetchCollectionSettingsWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/cnyPayList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 上传图片文件 */
+ (void)uploadImageWithParams:(NSDictionary *)params imageArray:(NSArray *)imageArray mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/upload/img" method:RequestMethodPost bodyParams:params imageArray:imageArray mapper:mapper showHUD:showHUD success:^(BaseResponseModel *response) {
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 实名认证 */
+ (void)fetchRealNameVerifyWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/verify" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 添加收款方式 */
+ (void)fetchAddPaymentWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/cnyPayAdd" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 删除收款方式 */
+ (void)fetchDeletePaymentWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/cnyPayDel" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 个人资产信息 */
+ (void)fetchAssetsInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/wallet" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 资产详情 */
+ (void)fetchAssetsDetailWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/walletDetail" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 流水记录 */
+ (void)fetchRecordsWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/cashflow" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 全部币种 */
+ (void)fetchSymbolListWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/symbolsList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 流水类型 */
+ (void)fetchRecordTypeWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/flowTypeList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 充币地址 */
+ (void)fetchRechargeAddressWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/platformAddress" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 充币提币记录 */
+ (void)fetchRechargeOrWithdrawRecordWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/coinRecord" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 提币页面信息 */
+ (void)fetchWithdrawInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/withdrawPage" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 提币 */
+ (void)fetchSubmitWithdrawWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/withdrawCoin" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 资产划转页面信息 */
+ (void)fetchTransferInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/convertPage" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 资产划转 */
+ (void)fetchSubmitTransferWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/convert" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 合约页面信息 */
+ (void)fetchContractInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/contractPage" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 币种行情 */
+ (void)fetchCurrencyQuotesWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/huobiTicket" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 币种交易信息 */
+ (void)fetchCurrencyDealInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/tradeList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 合约订单列表 */
+ (void)fetchContractOrderListWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/contractList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 币币交易页面信息 */
+ (void)fetchCoinInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/currencyPage" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 币币委托、记录 */
+ (void)fetchCoinCommissionOrRecordsWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/currencyRecord" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 币币交易 */
+ (void)fetchSubmitCoinDealWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/currency" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 撤销币币交易委托单 */
+ (void)fetchRevocationCommissionWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/cancelCurrency" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 法币交易（我要购买、我要出售）列表 */
+ (void)fetchFiatOrderListWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/tradeList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 下单购买 */
+ (void)fetchFiatOrderBuyWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/tradeBuy" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 法币交易-订单页面信息 */
+ (void)fetchFiatOrderInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/tradeBuyWaitPage" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 待付款页面-取消订单前调用（获取提示信息）*/
+ (void)fetchFiatOrderCancelTipWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/tradeCancelPre" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//待付款页面-取消订单
+ (void)fetchFiatOrderCancelWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/tradeCancel" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 我的订单-（购买订单、出售订单） */
+ (void)fetchMineOrderListWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/otcBillList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 待付款页面-已完成付款 */
+ (void)fetchOrderFinishPayWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/tradePaid" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 提交申诉 */
+ (void)fetchSubmitAppealWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/tradeAppeal" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 挂单买卖-挂单出售-收款方式 */
+ (void)fetchPaymentMethodWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/otcPayMethod" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 下单出售 */
+ (void)fetchOrderSellWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/tradeSell" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 承兑商页面保证金信息情况 */
+ (void)fetchAcceptorMarginInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/legalMgrPage" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 申请成为承兑商 */
+ (void)fetchApplyToBecomeAnAcceptorWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/deposit" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 挂单购买 */
+ (void)fetchPendingOrderPurchaseWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/otcBuy" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 我的订单（挂单购买、出售订单） */
+ (void)fetchMinePendingOrderListWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/otcOrderList" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 挂单中-撤单 */
+ (void)fetchMinePendingOrderCancelWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/cancelOrder" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 挂单出售页面信息 */
+ (void)fetchMinePendingOrderSellInfoWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/otcSellPage" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 挂单出售 */
+ (void)fetchPendingOrderSellWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/otcSell" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 退还保证金 */
+ (void)fetchRefundDepositWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/backDeposit" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 合约交易 */
+ (void)fetchSubmitContractWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/contract" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 平仓 */
+ (void)fetchCloseingWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/outContract" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 撤销合约委托 */
+ (void)fetchCancelContractWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/cancelContract" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 止盈止损 */
+ (void)fetchTabkeProfitAndStopLossWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/contractPl" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 获取某个币种的k线图数据 */
+ (void)fetchKLineWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/kline" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 合约最新成交价 */
+ (void)fetchContractNewPriceWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/currentTrade" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 合约简介 */
+ (void)fetchContractIntroductionWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/currentInfo" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 联系客服 */
+ (void)fetchServiceWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/contact" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 强制更新 */
+ (void)fetchUpdateAppVersionWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/version" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 放币 */
+ (void)fetchPutMoneyWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/otcFinish" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 补缴押金页面信息 */
+ (void)fetchMakeUpDepositWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/makeUpDepositPage" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 提交补缴 */
+ (void)fetchSubmitDepositWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/makeUpDeposit" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 提交充币 */
+ (void)fetchSubmitRechargeWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/recharge" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/** 白皮书详情 */
+ (void)fetchWhiteBookWithParams:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [[HttpManager sharedManager] requestWithUrl:@"/api/common/whiteBookDetail" method:RequestMethodPost bodyParams:params mapper:mapper showHUD:showHUD success:^(BaseResponseModel *responseModel) {
        success(responseModel);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
