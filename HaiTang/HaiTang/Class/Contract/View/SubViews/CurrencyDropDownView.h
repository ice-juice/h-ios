//
//  CurrencyDropDownView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/27.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyDropDownView : BaseView
- (void)showView;
- (void)closeView;
- (void)setViewWithModel:(id)model;

//选择币种
@property (nonatomic, copy) void (^onDidSelectSymbolAtIndexBlock)(NSString *symbol);

@end

NS_ASSUME_NONNULL_END
