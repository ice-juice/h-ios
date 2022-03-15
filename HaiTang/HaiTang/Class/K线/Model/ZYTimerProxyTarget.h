//
//  ZYTimerProxyTarget.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYTimerProxyTarget : NSProxy
//消息重定向的处理对象
@property (nonatomic, weak) id target;

@end

NS_ASSUME_NONNULL_END
