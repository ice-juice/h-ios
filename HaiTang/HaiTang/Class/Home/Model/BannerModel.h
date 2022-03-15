//
//  BannerModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : BaseModel
@property (nonatomic, copy) NSString *img;        //图片
@property (nonatomic, copy) NSString *link;       //链接
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
