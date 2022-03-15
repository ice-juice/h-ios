//
//  CacheManager.m
//  MeiYi
//
//  Created by XQ on 2019/1/30.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import "CacheManager.h"

static CacheManager *manager = nil;

@implementation CacheManager

+ (CacheManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CacheManager alloc] init];
    });
    return manager;
}

- (BOOL)saveDatas:(BaseModel *)model toCachePaths:(NSString *)cachePath {
    if (model) {
        return [NSKeyedArchiver archiveRootObject:model toFile:cachePath];
    }
    return NO;
}

- (BOOL)saveArrayDatas:(NSArray *)arrayModel toCachePaths:(NSString *)cachePath {
    if (arrayModel) {
        return [NSKeyedArchiver archiveRootObject:arrayModel toFile:cachePath];
    }
    return NO;
}

- (BOOL)saveStrongDatas:(id)model toCachePaths:(NSString *)cachePath {
    if (model) {
        return [NSKeyedArchiver archiveRootObject:model toFile:cachePath];
    }
    return NO;
}

- (BaseModel *)getDatasFromCachePaths:(NSString *)cachePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    }
    
    return nil;
}

- (NSArray *)getArrayDatasFromCachePaths:(NSString *)cachePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    }
    
    return nil;
}

@end
