//
//  PhoneCodeModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/11.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneCodeModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//类型 0:国内 1:国外
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
