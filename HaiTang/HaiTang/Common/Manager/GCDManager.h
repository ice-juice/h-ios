//
//  GCDManager.h
//  MeiYi
//
//  Created by XQ on 2019/1/30.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDManager : NSObject

+ (GCDManager *)sharedManager;

/**
 *  添加一个异步任务，并立即执行
 */
- (void)addAsyncTask:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
