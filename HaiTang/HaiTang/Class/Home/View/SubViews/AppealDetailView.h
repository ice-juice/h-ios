//
//  AppealDetailView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppealDetailView : BaseView
- (void)showView;
- (void)closeView;
- (void)setViewWithModel:(id)model;

//0-查看自己的 1-查看其他人的
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
