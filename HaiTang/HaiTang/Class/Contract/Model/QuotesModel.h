//
//  QuotesModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/26.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuotesModel : BaseModel
@property (nonatomic, copy) NSString *symbol;          //币种
@property (nonatomic, copy) NSString *high;            //最高价格
@property (nonatomic, copy) NSString *amount;          //交易数量(24H)
@property (nonatomic, copy) NSString *low;             //最低价
@property (nonatomic, copy) NSString *rose;            //涨跌幅（后面加上%）
@property (nonatomic, copy) NSString *close;           //最新行情价
@property (nonatomic, copy) NSString *open;            //开盘价
@property (nonatomic, copy) NSString *cny;             //折合人民币
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *quotes_id;
@property (nonatomic, copy) NSString *number;           //保留小数点位数
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *vol;

@property (nonatomic, copy) NSString *type;             //类型 0-币币 1-永续合约

@end

NS_ASSUME_NONNULL_END
