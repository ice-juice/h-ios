//
//  OrderModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/27.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : BaseModel
@property (nonatomic, copy) NSString *coin;          //币种
@property (nonatomic, copy) NSString *lowNumber;     //最小数量
@property (nonatomic, copy) NSString *lowPrice;      //最小金额
@property (nonatomic, copy) NSString *nickName;      //昵称
@property (nonatomic, copy) NSString *payMethod;     //收款方式
@property (nonatomic, copy) NSString *restNumber;    //数量
@property (nonatomic, copy) NSString *sellId;        //购买id
@property (nonatomic, copy) NSString *unitPrice;     //单价

@property (nonatomic, copy) NSString *orderType;     //订单类型 0-购买 1-出售
@property (nonatomic, copy) NSString *payMethodImgName;//支付方式图片名

/**
 下单购买
 */
@property (nonatomic, copy) NSString *orderNo;

/**
 出售列表
 */
@property (nonatomic, copy) NSString *buyId;          //出售id

/**
 法币交易-订单页面信息
 coin 币种
 orderNo 订单号
 payMethod 支付方式
 unitPrice 购买单价
 */
@property (nonatomic, copy) NSString *bank;           //银行
@property (nonatomic, copy) NSString *billId;         //交易id
@property (nonatomic, copy) NSString *branch;         //支行
@property (nonatomic, copy) NSString *cny;            //订单金额
@property (nonatomic, copy) NSString *createTime;     //下单时间
@property (nonatomic, copy) NSString *markNo;         //参考号
@property (nonatomic, copy) NSString *number;         //购买数量
@property (nonatomic, copy) NSString *payAccount;     //收款账号
@property (nonatomic, copy) NSString *payImg;         //收款二维码
@property (nonatomic, copy) NSString *payName;        //收款人
@property (nonatomic, copy) NSString *sellName;       //卖家
@property (nonatomic, copy) NSString *status;         //状态 WAIT-待付款 WAIT-COIN:待放币、已付款 CANCEL：已取消 FINISH-已完成 APPEAL-申诉中
@property (nonatomic, copy) NSString *type;           //下单类型 BUY-购买 SELL-出售
@property (nonatomic, copy) NSString *cancelTime;     //取消时间
@property (nonatomic, copy) NSString *payTime;        //付款时间
@property (nonatomic, copy) NSString *createTimestamp;//下单时间戳
@property (nonatomic, copy) NSString *payTimestamp;   //付款时间戳
@property (nonatomic, copy) NSString *now;            //当前时间戳
@property (nonatomic, copy) NSString *content;        //买方申诉内容
@property (nonatomic, copy) NSString *img;            //买方申诉凭证
@property (nonatomic, copy) NSString *duty;           //责任方(BUY-买方责任 SELL-卖方责任 NO-双方无责)
@property (nonatomic, copy) NSString *appealStatus;   //申诉状态(待处理-CHECK、已取消-CANCEL、已放币-PASS)
@property (nonatomic, copy) NSString *atime;          //买方申诉时间
@property (nonatomic, copy) NSString *appealType;     //申诉方(BUY-买方 SELL-卖方)
@property (nonatomic, copy) NSString *content1;       //卖方申诉内容
@property (nonatomic, copy) NSString *img1;           //卖方申诉凭证
@property (nonatomic, copy) NSString *atime1;         //卖方申诉时间
@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *payMethodString; //支付方式

/**
 我的订单
 */
@property (nonatomic, copy) NSString *buyName;        //买方
@property (nonatomic, copy) NSString *finishTime;     //完成时间

/**
 挂单出售
 */
@property (nonatomic, copy) NSString *totalPrice;     //总额

/**
 我要挂单- 挂单出售-页面信息
 type - 币种
 */
@property (nonatomic, copy) NSString *realStatus;     //是否实名认证 0:否 1:是 2:审核中
@property (nonatomic, copy) NSString *price;          //可用
@property (nonatomic, copy) NSString *pageType;       //SELL-出售 BUY-购买

@end

NS_ASSUME_NONNULL_END
