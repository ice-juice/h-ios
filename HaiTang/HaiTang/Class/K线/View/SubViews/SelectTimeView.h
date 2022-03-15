//
//  SelectTimeView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectTimeView : BaseView
- (void)showViewWithX:(CGFloat)x withY:(CGFloat)y;
- (void)closeView;

@property (nonatomic, copy) NSArray<NSString *> *arrayTableDatas;
@property (nonatomic, copy) void (^onSelectRowAtIndex)(NSInteger index);
@property (nonatomic, copy) void (^onCloseViewBlock)(void);

@end

NS_ASSUME_NONNULL_END
