//
//  BaseMainViewModel.h
//  BlueLeaf
//
//  Created by XQ on 2018/12/17.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseMainViewModel : NSObject

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger currentRefreshStatus;   // 当前刷新状态
@property (nonatomic, assign) BOOL showHUD; // 是否显示加载动画

@end

NS_ASSUME_NONNULL_END
