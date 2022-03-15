//
//  SharePopupView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SharePopupView : BaseView
- (void)showView;
- (void)closeView;
- (void)setViewWithModel:(id)model;

//当前价格
@property (nonatomic, strong) UILabel *lbCurrentPrice;

@end

NS_ASSUME_NONNULL_END
