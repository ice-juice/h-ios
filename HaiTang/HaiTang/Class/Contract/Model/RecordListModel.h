//
//  RecordListModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RecordModel;

@interface RecordListModel : BaseModel
@property (nonatomic, copy) NSString *countPrice;
@property (nonatomic, copy) NSString *pageType;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *usedPrice;
@property (nonatomic, strong) RecordModel *records;

@end

NS_ASSUME_NONNULL_END
