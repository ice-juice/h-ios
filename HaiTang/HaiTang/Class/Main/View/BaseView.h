//
//  BaseView.h
//  BlueLeaf
//
//  Created by XQ on 2018/12/18.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseView : UIView

/** 子类重写绘制UI */
- (void)setupSubViews;

/** 子类重写添加事件绑定 */
- (void)setupEvent;

@end

NS_ASSUME_NONNULL_END
