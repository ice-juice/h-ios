//
//  ProtocolModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/20.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProtocolModel : BaseModel
/** 内容  */
@property (nonatomic, copy) NSString *content;
/** 标题 */
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
