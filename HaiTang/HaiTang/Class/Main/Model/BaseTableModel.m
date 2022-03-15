//
//  BaseTableModel.m
//  BlueLeaf
//
//  Created by XQ on 2019/1/5.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import "BaseTableModel.h"

@implementation BaseTableModel

#pragma mark - Life Cycle
- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithImageName:nil title:title subTitle:nil];
}

- (instancetype)initWithImageName:(NSString *)imageName {
    return [self initWithImageName:_imageName title:nil subTitle:nil];
}

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title {
    return [self initWithImageName:imageName title:title subTitle:nil];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    return [self initWithImageName:nil title:title subTitle:subTitle];
}

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle {
    self = [super init];
    if (self) {
        _imageName = imageName;
        _title = title;
        _subTitle = subTitle;
    }
    
    return self;
}

#pragma mark - Setter And Getter
- (NSString *)title {
    if (!_title) {
        return @"";
    }
    
    return _title;
}

- (NSString *)subTitle {
    if (!_subTitle) {
        return @"";
    }
    
    return _subTitle;
}

@end
