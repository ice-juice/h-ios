//
//  BaseMainViewModel.m
//  BlueLeaf
//
//  Created by XQ on 2018/12/17.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import "BaseMainViewModel.h"

@implementation BaseMainViewModel

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _pageNo = 1;
        _pageSize = 10;
        _currentRefreshStatus = RefreshStatusPullDown;
    }
    
    return self;
}

@end
