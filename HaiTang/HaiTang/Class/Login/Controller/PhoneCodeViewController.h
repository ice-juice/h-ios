//
//  PhoneCodeViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/11.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneCodeViewController : BaseViewController
//手机区号
@property (nonatomic, copy) void (^onSelectPhoneCodeBlock)(NSString *phoneCode);

@end

NS_ASSUME_NONNULL_END
