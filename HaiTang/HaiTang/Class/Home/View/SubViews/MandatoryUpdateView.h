//  强制更新
//  MandatoryUpdateView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MandatoryUpdateView : BaseView
- (void)showViewWithContent:(NSString *)content;
- (void)closeView;

@property (nonatomic, copy) void (^onBtnWithUpdateVersionBlock)(void);

@end

NS_ASSUME_NONNULL_END
