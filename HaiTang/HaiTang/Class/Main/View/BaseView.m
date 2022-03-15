//
//  BaseView.m
//  BlueLeaf
//
//  Created by XQ on 2018/12/18.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        [self setupEvent];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubViews];
        [self setupEvent];
    }

    return self;
}

- (void)setupSubViews {
    
}

- (void)setupEvent {
    
}

@end
