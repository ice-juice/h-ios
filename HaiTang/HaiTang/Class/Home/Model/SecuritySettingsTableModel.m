//
//  SecuritySettingsTableModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SecuritySettingsTableModel.h"

@implementation SecuritySettingsTableModel
- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle isBinding:(nonnull NSString *)isBinding {
    self = [super initWithTitle:title subTitle:subTitle];
    if (self) {
        _isBinding = isBinding;
    }
    return self;
}

@end
