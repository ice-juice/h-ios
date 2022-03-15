//
//  ChooseAccountPopupView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/30.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class NewModel;

@interface ChooseAccountPopupView : BaseView
- (void)showView;
- (void)closeView;
- (void)setViewWithModel:(id)model;

//选择账号
@property (nonatomic, copy) void (^didSelectAccountAtIndexBlock)(NewModel *newModel);

@end

NS_ASSUME_NONNULL_END
