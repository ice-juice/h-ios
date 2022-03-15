//
//  UIControl+Category.h
//  DouYue
//
//  Created by 吴紫颖 on 2020/9/27.
//  Copyright © 2020 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Category)
@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;// 可以用这个给重复点击加间隔

@end

NS_ASSUME_NONNULL_END
