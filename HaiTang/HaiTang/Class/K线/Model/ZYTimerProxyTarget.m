//
//  ZYTimerProxyTarget.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ZYTimerProxyTarget.h"

@implementation ZYTimerProxyTarget
//讲消息重定向给控制器处理
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
