//
//  NewListModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NewModel;

@interface NewListModel : BaseModel
@property (nonatomic, strong) NSArray<NewModel *> *records;

@end

NS_ASSUME_NONNULL_END
