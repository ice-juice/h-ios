//
//  HomeMarketView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2021/2/3.
//  Copyright © 2021 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeMarketView : BaseView
//选择合约或币币
@property (nonatomic, copy) void (^onDidSelectContractOrCoinBlock)(NSString *type);
//查看k线
@property (nonatomic, copy) void (^onCheckKlineBlock)(NSString *symbol);

- (void)setViewWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
