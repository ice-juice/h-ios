//
//  NewModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/20.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewModel : BaseModel
/**
 平台公告列表
 */
@property (nonatomic, copy) NSString *carouselId;           //公告id
@property (nonatomic, copy) NSString *content;              //内容
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat cellHeight;

/**
 帮助中心
 content
 createTime
 problemId
 remark              类型
 title
 */
@property (nonatomic, copy) NSString *problemId;
@property (nonatomic, copy) NSString *remark;

/**
 收款方式
 */
@property (nonatomic, copy) NSString *idcard;      //账号
@property (nonatomic, copy) NSString *img;         //图片
@property (nonatomic, copy) NSString *name;        //姓名
@property (nonatomic, copy) NSString *paymentId;   //id
@property (nonatomic, copy) NSString *type;        //收款类型 ALI_PAY-支付宝 WE_CHAT微信 BANK-银行卡 PAYPAL
@property (nonatomic, copy) NSString *imgName;

@end

NS_ASSUME_NONNULL_END
