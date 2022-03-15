//
//  ContractTableCell.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class RecordSubModel;

@interface ContractTableCell : BaseTableViewCell
//止盈止损
@property (nonatomic, copy) void (^onBtnSetTakeProfitAndStopLossBlock)(NSString *compactId);
//平仓
@property (nonatomic, copy) void (^onBtnCloseingBlock)(RecordSubModel *subModel);
//分享
@property (nonatomic, copy) void (^onBtnShareBlock)(RecordSubModel *subModel);

@end

NS_ASSUME_NONNULL_END
