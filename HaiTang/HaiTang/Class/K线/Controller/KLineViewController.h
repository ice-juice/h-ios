//
//  KLineViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLineViewController : BaseViewController
@property (nonatomic, copy) NSString *type;    //类型  永续-1 币币-0
@property (nonatomic, copy) NSString *symbol;  //币种

@end

NS_ASSUME_NONNULL_END
