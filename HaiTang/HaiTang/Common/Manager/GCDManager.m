//
//  GCDManager.m
//  MeiYi
//
//  Created by XQ on 2019/1/30.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import "GCDManager.h"

static GCDManager *manager = nil;

@interface GCDManager ()

@property (nonatomic, strong) NSOperationQueue *mainQueue;  // 主队列
@property (nonatomic, strong) NSOperationQueue *otherQueue; // 其他队列（子队列）

@end

@implementation GCDManager

+ (GCDManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GCDManager alloc] init];
    });
    return manager;
}

#pragma mark - External Interface
- (void)addAsyncTask:(dispatch_block_t)block {
    [self.otherQueue addOperationWithBlock:block];
}

#pragma mark - Setter And Getter
- (NSOperationQueue *)mainQueue {
    if (!_mainQueue) {
        _mainQueue = [NSOperationQueue mainQueue];
    }
    
    return _mainQueue;
}

- (NSOperationQueue *)otherQueue {
    if (!_otherQueue) {
        _otherQueue = [[NSOperationQueue alloc] init];
    }
    
    return _otherQueue;
}

@end
