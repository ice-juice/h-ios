//
//  FiatOrderDetailTableHeaderView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FiatOrderDetailTableHeaderView : BaseView

@property (nonatomic, strong) UIButton *btnCountDown;

- (void)setViewWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
