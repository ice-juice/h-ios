//
//  GlobalEnum.h
//  xbtce
//
//  Created by 吴紫颖 on 2020/7/8.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#ifndef GlobalEnum_h
#define GlobalEnum_h

typedef NS_ENUM(NSInteger, RefreshStatus) {
    /** 下拉刷新 */
    RefreshStatusPullDown,
    /** 上拉加载 */
    RefreshStatusPullUp
};

typedef NS_ENUM(NSInteger, HomeTableCellType) {
    HomeTableCellTypeOtherFeatures,           //其他功能
    HomeTableCellTypeHelpCenterAndNotice,     //帮助中心、平台公告
    HomeTableCellTypeQuotes                   //行情
};

typedef NS_ENUM(NSInteger, FiatOrderStatus) {
    FiatOrderStatusFinish,                    //已完成
    FiatOrderStatusWaitPayment,               //待付款
    FiatOrderStatusPaid,                      //已付款
    FiatOrderStatusCancelled,                 //已取消
    FiatOrderStatusAppealing,                 //申诉中
    FiatOrderStatusPendingPayment,            //待收款
    FiatOrderStatusWaitPutMoney,              //待放币
    FiatOrderStatusPendingOrder,              //挂单中
    FiatOrderStatusOrderCancelled             //已撤单
};

typedef NS_ENUM(NSInteger, FiatOrderDetailCellType) {
    FiatOrderDetailCellTypeText,               //纯文字
    FiatOrderDetailCellTypeTextAndCopy,        //复制文字
    FiatOrderDetailCellTypeArrow,              //箭头
    FiatOrderDetailCellTypeImage               //图片
};

typedef NS_ENUM(NSInteger, MyDepositStatus) {
    MyDepositStatusNormal,                     //我的保证金
    MyDepositStatusMakeUp,                     //补缴
    MyDepositStatusConfirmMakeUp,              //确认补缴
    MyDepositStatusRetun                       //退还中
};

typedef NS_ENUM(NSInteger, RecordType) {
    RecordTypeCloseing,                        //平仓记录
    RecordTypeDeal,                            //成交记录
    RecordTypeRecharge,                        //充币记录
    RecordTypeWalletAssets,                    //钱包资产记录
    RecordTypeContractAssets,                  //合约资产记录
    RecordTypeCoinAssets,                      //币币资产记录
    RecordTypeFiatAssets,                      //法币资产记录
    RecordTypeWithdraw                         //提币记录
};

typedef NS_ENUM(NSInteger, BindType) {
    BindTypePhone,                              //绑定手机
    BindTypeEmail                               //绑定邮箱
};

typedef NS_ENUM(NSInteger, AddPaymentType) {
    AddPaymentTypeAlipay,                       //添加支付宝
    AddPaymentTypeWeChat,                       //添加微信
    AddPaymentTypeBankCard,                     //添加银行卡
    AddPaymentTypePayPal                        //添加PayPal
};

typedef NS_ENUM(NSInteger, ModifyType) {
    ModifyTypeNickName,                          //法币交易昵称
    ModifyTypeAssetsPassword,                    //资产密码
    ModifyTypeLoginPassword                      //登录密码
};

typedef NS_ENUM(NSInteger, USDTAssetsType) {
    USDTAssetsTypeWallet,                        //USDT钱包资产
    USDTAssetsTypeContract,                      //USDT合约资产
    USDTAssetsTypeCoin,                          //USDT币币资产
    USDTAssetsTypeFiat                           //USDT法币资产
};

typedef NS_ENUM(NSInteger, VerifyCodeType) {
    VerifyCodeTypePhone,                 //手机注册
    VerifyCodeTypeEmail,                 //邮箱注册
    VerifyCodeTypePhoneValidate,         //验证手机
    VerifyCodeTypeEmailValidate          //验证邮箱
};

typedef NS_ENUM(NSInteger, PopupType) {
    PopupTypeAuthentication,             //实名认证
    PopupTypeReturn,                     //退还
    PopupTypeCancelOrder,                //取消订单
    PopupTypeBackUpDeposit,              //补缴保证金
    PopupTypeCancelPendingBuyOrder,      //撤购买订单
    PopupTypeCancelPendingSellOrder,     //撤出售订单
    PopupTypeCancelContract,             //撤销合约委托
    PopupTypeCloseingAll,                //一键平仓
    PopupTypeCancelAllContract           //撤销全部合约委托
};

#endif /* GlobalEnum_h */
