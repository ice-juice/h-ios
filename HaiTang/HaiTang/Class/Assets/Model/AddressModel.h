//
//  AddressModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : BaseModel
@property (nonatomic, copy) NSString *address;         //地址
@property (nonatomic, copy) NSString *memoTagValue;    //EOS、XRP使用的Memo或tag值
@property (nonatomic, copy) NSString *symbol;

@end

NS_ASSUME_NONNULL_END
