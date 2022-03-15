//
//  AcceptorModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AcceptorModel : BaseModel
/**
 押金缴纳情况
 0-待补缴
 1-全部缴纳
 2-未开通
 3:押金退还审核中
 4:需要成为承兑商
 5-已获得承兑商权限
 6-承兑商申请审核中
 7-承兑商审核失败
 */
@property (nonatomic, copy) NSString *deposit;
//昵称 为空则需要补填
@property (nonatomic, copy) NSString *nickName;
//实名认证
@property (nonatomic, copy) NSString *realStatus;
//保证金金额
@property (nonatomic, copy) NSString *USDT;
//可用余额
@property (nonatomic, copy) NSString *usedPrice;
//押金缴纳情况为0的时候，该值为剩余保证金金额
@property (nonatomic, copy) NSString *number;
//是否申请过 N:否 Y:是
@property (nonatomic, copy) NSString *haveAppeal;

/**
 补缴押金页面信息
 coin-币种
 number-补缴数量
 */
@property (nonatomic, copy) NSString *coin;

@end

NS_ASSUME_NONNULL_END
