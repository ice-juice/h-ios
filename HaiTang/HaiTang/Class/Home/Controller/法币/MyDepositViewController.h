//
//  MyDepositViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDepositViewController : BaseViewController
//保证金状态
@property (nonatomic, assign) MyDepositStatus depositStatus;

@end

NS_ASSUME_NONNULL_END
