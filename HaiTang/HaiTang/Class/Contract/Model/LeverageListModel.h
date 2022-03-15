//
//  LeverageListModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/26.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeverageListModel : BaseModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *leverage_id;

@end

NS_ASSUME_NONNULL_END
