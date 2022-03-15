//
//  SelectCardTypeView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectCardTypeView : BaseView
- (void)showView;
- (void)closeView;

//选择证件类型
@property (nonatomic, copy) void (^onSelectCardTypeBlock)(NSString *title);

@end

NS_ASSUME_NONNULL_END
