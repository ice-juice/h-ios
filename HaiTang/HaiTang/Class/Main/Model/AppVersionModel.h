//
//  AppVersionModel.h
//  GoldenHShield
//
//  Created by 吴紫颖 on 2020/5/7.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppVersionModel : BaseModel
@property (nonatomic, copy) NSString *address;       //地址
@property (nonatomic, copy) NSString *version;       //版本
@property (nonatomic, copy) NSString *content;       //内容

@end

NS_ASSUME_NONNULL_END
