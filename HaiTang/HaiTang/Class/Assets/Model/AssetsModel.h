//
//  AssetsModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class AssetsListModel;

@interface AssetsModel : BaseModel
@property (nonatomic, strong) NSArray<AssetsListModel *> *list;      //资产账户列表
@property (nonatomic, copy) NSString *accountTotalPrice;             //账户总额
@property (nonatomic, copy) NSString *cny;                           //资产估值折合人民币
@property (nonatomic, copy) NSString *valuationTotalPrice;           //资产估值

/**
 资产详情
 */
@property (nonatomic, copy) NSString *p1;    //总额或权益账户
@property (nonatomic, copy) NSString *p2;    //冻结或未实现盈亏
@property (nonatomic, copy) NSString *p3;    //可用或仓位保证金
@property (nonatomic, copy) NSString *p4;    //可用保证金
@property (nonatomic, copy) NSString *p5;    //委托保证金
@property (nonatomic, copy) NSString *p6;
@property (nonatomic, copy) NSString *p7;
@property (nonatomic, copy) NSString *page;  //页面
@property (nonatomic, copy) NSString *type;  //类型

/**
 提现页面信息
 */
@property (nonatomic, copy) NSString *min;        //最小提币量
@property (nonatomic, copy) NSString *price;      //可提数量
@property (nonatomic, copy) NSString *fee;        //手续费
@property (nonatomic, copy) NSString *minSection; //最小区间值
@property (nonatomic, copy) NSString *maxSection; //最大区间值

/**
 资产划转页面信息
 price
 */
@property (nonatomic, copy) NSString *unit;        //币种

@end

NS_ASSUME_NONNULL_END
