//
//  DataModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : BaseModel
//Y-正确 N-不正确
@property (nonatomic, copy) NSString *isTrue;

@end

NS_ASSUME_NONNULL_END
