//
//  KLineTableHeaderView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KLineTableHeaderViewDelegate <BaseMainViewDelegate>
//选择时间
- (void)onDidSelectTimeAtIndex:(NSString *)index;
//更多
- (void)onDidSelectMoreAtIndex:(NSString *)index;
//指标
- (void)onDidSelectZhiBiaoAtIndex:(NSString *)index;
@end

@interface KLineTableHeaderView : BaseMainView

@property (nonatomic, assign) CGFloat scrollValue;


@end

NS_ASSUME_NONNULL_END
