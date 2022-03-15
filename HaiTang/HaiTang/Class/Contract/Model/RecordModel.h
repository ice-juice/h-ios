//
//  RecordModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RecordSubModel;

@interface RecordModel : BaseModel
@property (nonatomic, strong) NSArray<RecordSubModel *> *records;

@end

NS_ASSUME_NONNULL_END
