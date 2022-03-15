//
//  CacheManager.h
//  MeiYi
//
//  Created by XQ on 2019/1/30.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheManager : NSObject

+ (CacheManager *)sharedManager;

/**
 *  desc : 缓存数据到本地
 *  model : 需要缓存的model
 *  cachePath : 缓存的目录
 *
 *  return : 缓存结果
 */
- (BOOL)saveDatas:(BaseModel *)model toCachePaths:(NSString *)cachePath;

/**
 *  desc : 缓存数据到本地
 *  model : 需要缓存的model
 *  cachePath : 缓存的目录
 *
 *  return : 缓存结果
 */
- (BOOL)saveArrayDatas:(NSArray *)arrayModel toCachePaths:(NSString *)cachePath;

- (BOOL)saveStrongDatas:(id)model toCachePaths:(NSString *)cachePath;

/**
 *  desc : 取出缓存的model
 *  cachePath : 缓存的目录
 *
 *  return : 取出的数据
 */
- (BaseModel *)getDatasFromCachePaths:(NSString *)cachePath;

- (NSArray *)getArrayDatasFromCachePaths:(NSString *)cachePath;

@end

NS_ASSUME_NONNULL_END
