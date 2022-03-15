//
//  DropDownView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DropDownView : BaseView
@property (nonatomic, copy) NSArray *arrayTableDatas;
//选择
@property (nonatomic, copy) void (^onDidSelectIndexBlock)(id obj);

- (void)showViewWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
- (void)closeView;

@end

NS_ASSUME_NONNULL_END
