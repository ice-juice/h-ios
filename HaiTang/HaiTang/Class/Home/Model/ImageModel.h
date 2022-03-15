//
//  ImageModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : BaseModel
@property (nonatomic, copy) NSString *src;        //图片路径
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
