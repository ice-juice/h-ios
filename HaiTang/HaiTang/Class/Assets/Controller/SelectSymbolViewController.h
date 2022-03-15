//
//  SelectSymbolViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectSymbolViewController : BaseViewController
//币种
@property (nonatomic, copy) NSString *symbol;
//充币-CHANGER,其他照旧
@property (nonatomic, copy) NSString *type;
//选择币种
@property (nonatomic, copy) void (^onSelectedSymbolBlock)(NSString *symbol);

@end

NS_ASSUME_NONNULL_END
