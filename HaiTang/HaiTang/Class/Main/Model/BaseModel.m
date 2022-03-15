//
//  BaseModel.m
//  iShop
//
//  Created by JY on 2018/6/7.
//  Copyright © 2018年 帝辰科技. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        u_int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        
        for (int i = 0; i < count; i++) {
            const char *propertyName = property_getName(properties[i]);
            NSString *key = [NSString stringWithUTF8String:propertyName];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(properties);
}

@end
