//
//  HttpManager.h
//
//  Created by XQ on 2018/6/7.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGet,
    RequestMethodPost,
    RequestMethodPut,
    RequestMethodDelete
};

@class BaseResponseModel;

@interface HttpManager : NSObject

+ (HttpManager *)sharedManager;

/** 接受body */
- (void)requestWithUrl:(NSString *)url method:(RequestMethod)method bodyParams:(NSDictionary *)bodyParams mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel *response))success failure:(void (^)(NSError *error))failure;

/** 接受body */
- (void)requestWithUrl:(NSString *)url method:(RequestMethod)method urlParams:(NSArray *)urlParams bodyParams:(NSDictionary *)bodyParams mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel *response))success failure:(void (^)(NSError *error))failure;

/** 请求绝对路径 */
- (void)requestWithAbsoluteUrl:(NSString *)url method:(RequestMethod)method bodyParams:(NSDictionary *)bodyParams mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/** 同步GET请求 */
- (void)syncGetWithUrl:(NSString *)url params:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void(^)(BaseResponseModel *responseModel))success failure:(void(^)(NSError *error))failure;

/** 上传图片 */
- (void)requestWithUrl:(NSString *)url method:(RequestMethod)method bodyParams:(NSDictionary *)bodyParams imageArray:(NSArray<UIImage *> *)imageArray mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel *response))success failure:(void (^)(NSError *error))failure;

@end
