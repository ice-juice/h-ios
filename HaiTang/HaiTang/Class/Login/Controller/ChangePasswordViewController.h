//
//  ChangePasswordViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordViewController : BaseViewController
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *verifyCode;

@end

NS_ASSUME_NONNULL_END
