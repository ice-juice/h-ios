//
//  AssetsListModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsListModel : BaseModel
@property (nonatomic, copy) NSString *list_id;
@property (nonatomic, copy) NSString *totalPrice;     //总额
@property (nonatomic, copy) NSString *type;           //币种
@property (nonatomic, copy) NSString *usedPrice;      //可用

@end

NS_ASSUME_NONNULL_END
