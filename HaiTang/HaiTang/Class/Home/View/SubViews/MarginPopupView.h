//
//  MarginPopupView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarginPopupView : BaseView
- (void)showViewWithPopupType:(PopupType)popupType;
- (void)closeView;
- (void)setViewWithModel:(id)model;

@property (nonatomic, copy) void (^onBtnWithYesBlock)(void);

@end

NS_ASSUME_NONNULL_END
