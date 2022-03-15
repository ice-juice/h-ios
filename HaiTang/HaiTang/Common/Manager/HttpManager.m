//
//  HttpManager.m
//
//  Created by XQ on 2018/6/7.
//  Copyright © 2018年 XQ. All rights reserved.
//  网络请求管理类

#import "HttpManager.h"
#import "BaseResponseModel.h"
#import <AFNetworking/AFNetworking.h>
#import "LoginViewController.h"
#import <UIKit/UIKit.h>

static HttpManager *_manager = nil;
static const int kRequestTimeoutInterval = 30;
@interface HttpManager ()
@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;
@property (nonatomic, strong) UIView *loadView;
@property (nonatomic, strong) UIImageView *imageViewLoad;
@end
@implementation HttpManager
+ (HttpManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

+ (instancetype)alloc {
    if (_manager) {
        NSException *exception = [NSException exceptionWithName:@"HttpManager Initialize Exception." reason:@"请使用HttpManager的单例方法." userInfo:nil];
        [exception raise];
    }
    return [super alloc];
}

- (AFHTTPSessionManager *)sessionManager {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [self requestSerializer];
    sessionManager.responseSerializer = self.responseSerializer;
    return sessionManager;
}

#pragma mark - HTTP请求方法
/** GET请求 */
- (void)getWithUrl:(NSString *)url params:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:url method:RequestMethodGet params:params mapper:mapper showHUD:showHUD success:success failure:failure];
}
/** POST请求 */
- (void)postWithUrl:(NSString *)url params:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:url method:RequestMethodPost params:params mapper:mapper showHUD:showHUD success:success failure:failure];
}
/** PUT请求 */
- (void)putWithUrl:(NSString *)url params:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:url method:RequestMethodPut params:params mapper:mapper showHUD:showHUD success:success failure:failure];
}
/** DELETE请求 */
- (void)deleteWithUrl:(NSString *)url params:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:url method:RequestMethodDelete params:params mapper:mapper showHUD:showHUD success:success failure:failure];
}
/* 接受params */
- (void)requestWithUrl:(NSString *)url method:(RequestMethod)method params:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel *responseModel))success failure:(void (^)(NSError *error))failure {
    //2020-05-21
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[AppDelegate sharedDelegate] isNetworkReachable]) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"暂无网络连接", nil) completionHandle:nil];
            return;
        }
    });
    [self showHUD:showHUD];
    NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //2020-05-14
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, urlString];
    NSString *requestMethod = [self stringRequestMethod:method];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:requestMethod URLString:[[NSURL URLWithString:requestUrl relativeToURL:nil] absoluteString] parameters:params error:&serializationError];
    if (serializationError && failure) {
        dispatch_async([self sessionManager].completionQueue ?: dispatch_get_main_queue(), ^{
            failure(serializationError);
        });
    }
    NSURLSessionDataTask *dataTask = [[self sessionManager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
                [self dismissHUD:showHUD];
                [self processError:error];
            }
        } else {
            if (success) {
                [self dismissHUD:showHUD];
                Logger(@"\n[** %@请求 **] \nREQUEST URL: %@ \nREQUEST PARAMS: %@ \nRESPONSE: %@ \n\n", requestMethod, requestUrl, [params mj_JSONString], [self responseToString:responseObject]);
                
                BaseResponseModel *responseModel = [self processResponse:responseObject mapper:mapper];
                if (responseModel) {
                    success(responseModel);
                }
            }
        }
    }];
    [dataTask resume];
}
/* 接受body */
- (void)requestWithUrl:(NSString *)url method:(RequestMethod)method bodyParams:(NSDictionary *)bodyParams mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel *response))success failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:url method:method urlParams:nil bodyParams:bodyParams mapper:mapper showHUD:showHUD success:success failure:failure];
}
/** 接受body */
- (void)requestWithUrl:(NSString *)url method:(RequestMethod)method urlParams:(NSArray *)urlParams bodyParams:(NSDictionary *)bodyParams mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel *response))success failure:(void (^)(NSError *error))failure {
    //2020-05-21
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[AppDelegate sharedDelegate] isNetworkReachable]) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"暂无网络连接", nil) completionHandle:nil];
            return;
        }
    });
    [self showHUD:showHUD];
        
    //废弃方法
//    __block NSString *requestUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 2020-05-14
    NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __block NSString *requestUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, urlString];
    if (urlParams && [urlParams isKindOfClass:[NSArray class]]) {
        [urlParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            requestUrl = [NSString stringWithFormat:@"%@/%@", requestUrl, obj];
        }];
    }
    NSString *requestMethod = [self stringRequestMethod:method];
    if (method == RequestMethodGet) {
        if (bodyParams) {
            requestUrl = [requestUrl stringByAppendingString:@"?"];
            [bodyParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:bodyParams.allKeys.lastObject]) {
                    requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, obj]];
                } else {
                    requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, obj]];
                }
            }];
        }
    }
    NSError *serializationError = nil;
    //stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding 2020-05-14
    NSMutableURLRequest *request = [self.bodyRequestSerializer requestWithMethod:requestMethod URLString:[[NSURL URLWithString:[requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] relativeToURL:nil] absoluteString] parameters:bodyParams error:&serializationError];
    if (serializationError && failure) {
        dispatch_async([self sessionManager].completionQueue ?: dispatch_get_main_queue(), ^{
            failure(serializationError);
        });
    }
    NSURLSessionDataTask *dataTask = [[self sessionManager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                [JYToastUtils dismiss];
                failure(error);
                [self dismissHUD:showHUD];
                [self processError:error];
            }
        } else {
            if (success) {
                [self dismissHUD:showHUD];
                Logger(@"\n[** %@请求 **] \nREQUEST URL: %@ \nREQUEST PARAMS: %@ \nRESPONSE: %@ \n\n", requestMethod, requestUrl, [bodyParams mj_JSONString], [self responseToString:responseObject]);
                BaseResponseModel *responseModel = [self processResponse:responseObject mapper:mapper];
                if (responseModel) {
                    success(responseModel);
                } else {
                    NSError *error = [[NSError alloc] init];
                    failure(error);
                }
            }
        }
    }];
    [dataTask resume];
}

/** 请求绝对路径 */
- (void)requestWithAbsoluteUrl:(NSString *)url method:(RequestMethod)method bodyParams:(NSDictionary *)bodyParams mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    //2020-05-21
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[AppDelegate sharedDelegate] isNetworkReachable]) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"暂无网络连接", nil) completionHandle:nil];
            return;
        }
    });
    [self showHUD:showHUD];
    //2020-05-14
    __block NSString *requestUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSString *requestMethod = [self stringRequestMethod:method];
    if (bodyParams) {
        requestUrl = [requestUrl stringByAppendingString:@"?"];
        [bodyParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:bodyParams.allKeys.lastObject]) {
                requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, obj]];
            } else {
                requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, obj]];
            }
        }];
    }
    NSError *serializationError = nil;
    //2020-05-14
    NSMutableURLRequest *request = [self.bodyRequestSerializer requestWithMethod:requestMethod URLString:[[NSURL URLWithString:[requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] relativeToURL:nil] absoluteString] parameters:nil error:&serializationError];
    if (method == RequestMethodPost) {
        [request setHTTPBody:[[bodyParams mj_JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (serializationError && failure) {
        dispatch_async([self sessionManager].completionQueue ?: dispatch_get_main_queue(), ^{
            failure(serializationError);
        });
    }
    NSURLSessionDataTask *dataTask = [[self sessionManager] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
                [self dismissHUD:showHUD];
                [self processError:error];
            }
        } else {
            if (success) {
                [self dismissHUD:showHUD];
                Logger(@"\n[** %@请求 **] \nREQUEST URL: %@ \nREQUEST PARAMS: %@ \nRESPONSE: %@ \n\n", requestMethod, requestUrl, [bodyParams mj_JSONString], [self responseToString:responseObject]);
//                NSDictionary *responseDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:nil];
//                if (responseDict) {
//                    success(responseDict);
//                } else {
//                    failure(nil);
//                }
                BaseResponseModel *responseModel = [self processResponse:responseObject mapper:mapper];
                if (responseModel) {
                    success(responseModel);
                } else {
                    NSError *error = [[NSError alloc] init];
                    failure(error);
                }
            }
        }
    }];
    [dataTask resume];
}
/**
 *  同步GET请求
 */
- (void)syncGetWithUrl:(NSString *)url params:(NSDictionary *)params mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel *responseModel))success failure:(void (^)(NSError *error))failure {
    //2020-05-21
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[AppDelegate sharedDelegate] isNetworkReachable]) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"暂无网络连接", nil) completionHandle:nil];
            return;
        }
    });
    [self showHUD:showHUD];
    //2020-05-14
    NSString *apiStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSString *requestMethod = [self stringRequestMethod:RequestMethodGet];
    NSError *serializationError = nil;
    //2020-05-14
    NSString *requestUrl = [apiStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:requestMethod URLString:requestUrl parameters:params error:&serializationError];
    // 创建同步链接
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [self dismissHUD:showHUD];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (responseObject) {
        [self dismissHUD:showHUD];
        Logger(@"\n[** %@请求 **] \nREQUEST URL: %@ \nREQUEST PARAMS: %@ \nRESPONSE: %@ \n\n", requestMethod, requestUrl, [params mj_JSONString], [self responseToString:responseObject]);
        BaseResponseModel *responseModel = [self processResponse:responseObject mapper:mapper];
        if (responseModel) {
            success(responseModel);
        }
    } else {
        failure(error);
        [self dismissHUD:showHUD];
        [self processError:error];
    }
}
/** 上传图片 */
- (void)requestWithUrl:(NSString *)url method:(RequestMethod)method bodyParams:(NSDictionary *)bodyParams imageArray:(NSArray<UIImage *> *)imageArray mapper:(id)mapper showHUD:(BOOL)showHUD success:(void (^)(BaseResponseModel *))success failure:(void (^)(NSError *))failure {
    //2020-05-21
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[AppDelegate sharedDelegate] isNetworkReachable]) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"暂无网络连接", nil) completionHandle:nil];
            return;
        }
    });
    [self showHUD:showHUD];
    __block NSString *requestUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSString *requestMethod = [self stringRequestMethod:method];
    if (method == RequestMethodGet) {
        requestUrl = [requestUrl stringByAppendingString:@"?"];
        if (bodyParams) {
            [bodyParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, obj]];
            }];
        }
    }
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.bodyRequestSerializer requestWithMethod:requestMethod URLString:[[NSURL URLWithString:[requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] relativeToURL:nil] absoluteString] parameters:nil error:&serializationError];
    if (method == RequestMethodPost) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:bodyParams];
        bodyParams = tempDic;
        [request setHTTPBody:[[bodyParams mj_JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (serializationError && failure) {
        dispatch_async([self sessionManager].completionQueue ?: dispatch_get_main_queue(), ^{
            failure(serializationError);
        });
    }    
    [[self sessionManager] POST:requestUrl parameters:bodyParams headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传图片
        [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(obj, 0.5);
            [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%luimage.png",(unsigned long)idx] mimeType:@"png"];
        }];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            [self dismissHUD:showHUD];
            Logger(@"\n[** %@请求 **] \nREQUEST URL: %@ \nREQUEST PARAMS: %@ \nRESPONSE: %@ \n\n", requestMethod, requestUrl, [bodyParams mj_JSONString], [self responseToString:responseObject]);
            BaseResponseModel *responseModel = [self processResponse:responseObject mapper:mapper];
            if (responseModel) {
                success(responseModel);
            } else {
                failure(nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            if (failure) {
                failure(error);
                [self processError:error];
            }
        }
    }];
}
#pragma mark - Private Method
- (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"fucai" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    if (certData) {
        securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    }
    return securityPolicy;
}
/* 处理HTTP RESPONSE */
- (BaseResponseModel *)processResponse:(id)response mapper:(id)mapper {
    if (!response) {
        Logger(@"服务器返回为空: %@", response);
        return nil;
    }
    NSDictionary *responseDict = nil;
    if ([response isKindOfClass:[NSDictionary class]]) {
        responseDict = response;
    } else {
        responseDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:(NSData *)response options:NSJSONReadingMutableContainers error:nil];
    }
    if (!responseDict) {
        Logger(@"服务器返回非字典: %@", response);
        response = [self responseToString:response];
        if ([response containsString:@"<!DOCTYPE html>"]) {
            return response;
        }
        return nil;
    }
    BaseResponseModel *responseModel = [BaseResponseModel mj_objectWithKeyValues:response];
    if ([responseModel.code isEqualToString:@"200"]) {
        responseModel.data = [NSObject mapperObjectWithResult:responseModel.data mapper:mapper];
        return responseModel;
    } else if ([responseModel.code isEqualToString:@"403"]) {
        // token 为空或失效
        [self tokenInvalid:nil];
        return nil;
    } else if ([responseModel.code isEqualToString:@"1005"]) {
        //token过期
        [self tokenInvalid:nil];
        return nil;
    } else if ([responseModel.code isEqualToString:@"21001"]) {
        //取消订单提示
        responseModel.data = [NSObject mapperObjectWithResult:responseModel.data mapper:mapper];
        return responseModel;
    } else {
        NSString *error = responseModel.msg;
        if ([error isKindOfClass:[NSString class]]) {
            if ([NSString isEmpty:error]) {
                error = responseModel.error;
            }
            if (![NSString isEmpty:error]) {
                NSString *errorMsg = @"";
                if ([responseModel.code isEqualToString:@"4011"]) {
                    errorMsg = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"今日三次取消", nil), error, NSLocalizedString(@"分钟内无法继续购买", nil)];
                } else if ([responseModel.code isEqualToString:@"21002"]) {
                    errorMsg = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"您今日已取消", nil), error, NSLocalizedString(@"如再次取消，将扣除您50%保证金，是否 继续取消", nil)];
                } else if ([responseModel.code isEqualToString:@"21001"]) {
                    errorMsg = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"您今日已取消2次，如再次取消，", nil), error, NSLocalizedString(@"分钟内无法下单购买，是否继续取消", nil)];
                } else if ([responseModel.code isEqualToString:@"4012"]) {
                    errorMsg = [NSString stringWithFormat:@"%@%@", error, NSLocalizedString(@"分钟内无法继续购买", nil)];
                } else {
                    errorMsg = error;
                }
                
                [JYToastUtils showLongWithStatus:errorMsg completionHandle:nil];
            }
        }
        return nil;
    }
}
// 转换成字符串信息
- (NSString *)responseToString:(id)response {
    NSData *data = (NSData *)response;
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
    }
    NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!responseStr) {
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        responseStr = [[NSString alloc] initWithData:data encoding:encoding];
    }
    return responseStr;
}

- (NSString *)stringRequestMethod:(RequestMethod)method {
    if (method == RequestMethodGet) {
        return @"GET";
    } else if (method == RequestMethodPost) {
        return @"POST";
    } else if (method == RequestMethodPut) {
        return @"PUT";
    } else if (method == RequestMethodDelete) {
        return @"DELETE";
    }
    return @"WARNING:请设置正确的HTTP请求方法";
}
// 构造Params请求头
- (AFHTTPRequestSerializer *)requestSerializer {
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置通用请求头字段
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
    [requestSerializer setValue:token forHTTPHeaderField:kToken];
    [requestSerializer setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    // 设置超时时间
    [requestSerializer willChangeValueForKey:@"timeoutInterval"];
    requestSerializer.timeoutInterval = kRequestTimeoutInterval;
    [requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return requestSerializer;
}
// 构造Body请求头
- (AFHTTPRequestSerializer *)bodyRequestSerializer {
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置通用请求头字段
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
    [requestSerializer setValue:token forHTTPHeaderField:kToken];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // 设置超时时间
    [requestSerializer willChangeValueForKey:@"timeoutInterval"];
    requestSerializer.timeoutInterval = kRequestTimeoutInterval;
    [requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return requestSerializer;
}
// 响应头
- (AFHTTPResponseSerializer *)responseSerializer {
    if (!_responseSerializer) {
        _responseSerializer = [AFHTTPResponseSerializer serializer];
        _responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/jpeg", @"application/x-www-form-urlencoded", @"multipart/form-data", @"application/octet-stream", nil];
    }
    return _responseSerializer;
}
// 判断Token是否过期
- (void)tokenInvalid:(id)response {
    [JYToastUtils dismiss];
    UIViewController *topViewController = [NSObject topViewController];
    if (topViewController && [topViewController isKindOfClass:[LoginViewController class]]) {
        Logger(@"栈顶控制器已经是登录页了");
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationInvalidToken object:nil];
}
// 处理错误信息
- (void)processError:(NSError *)error {
    Logger(@"REQUEST ERROR = %@\n", error);
    [JYToastUtils dismiss];
    NSInteger errorCode = error.code;
    NSString *errorMessage = error.localizedDescription;
    if (errorCode == -1001) {
        if ([errorMessage containsString:NSLocalizedString(@"请求超时", nil)] ||
            [errorMessage containsString:NSLocalizedString(@"The request timed out", nil)]) {
           // [JYToastUtils showLongWithStatus:NSLocalizedString(@"请求超时", nil) completionHandle:nil];
            return;
        }
    } else if (errorCode == -1004) {
        if ([errorMessage containsString:NSLocalizedString(@"未能连接到服务器", nil)] ||
            [errorMessage containsString:@"Could not connect to the server"]) {
            //[JYToastUtils showLongWithStatus:NSLocalizedString(@"未能连接到服务器", nil) completionHandle:nil];

            return;
        }
    } else if (errorCode == -1005) {
        if ([errorMessage containsString:NSLocalizedString(@"网络连接已中断", nil)] ||
            [errorMessage containsString:NSLocalizedString(@"The network connection was lost", nil)]) {
            //[JYToastUtils showLongWithStatus:NSLocalizedString(@"网络连接已中断", nil) completionHandle:nil];
            return;
        }
    } else if (errorCode == -1009) {
        if ([errorMessage containsString:NSLocalizedString(@"似乎已断开与互联网的连接", nil)] ||
            [errorMessage containsString:NSLocalizedString(@"The Internet connection appears to be offline", nil)]) {
            Logger(@"***** 无网络连接: -1009 ***** ");
            return;
        }
    } else if (errorCode == -1011) {
        if ([errorMessage containsString:NSLocalizedString(@"not found", nil)]) { // 404 500
            Logger(@"***** 无网络连接: 404 or 500 ***** ");
            return;
        } else if ([errorMessage containsString:NSLocalizedString(@"422", nil)]) { // 422
            Logger(@"***** 无网络连接: 422 ***** ");
            return;
        } else if ([errorMessage containsString:NSLocalizedString(@"503", nil)]) { // 503
            Logger(@"***** 无网络连接: 503 ***** ");
            return;
        } else if ([errorMessage containsString:NSLocalizedString(@"401", nil)]) { // 401
            [self tokenInvalid:nil];
            return;
        } else if ([errorMessage containsString:NSLocalizedString(@"412", nil)]) { // 412
            Logger(@"过期了");
            [self tokenInvalid:nil];
            return;
        } else if ([errorMessage containsString:NSLocalizedString(@"403", nil)]) { //403
            Logger(@"token过期");
            [self tokenInvalid:nil];
            return;
        }
    }
}
#pragma mark - ToastUtils
- (void)showHUD:(BOOL)showHUD
{
//    [JYToastUtils dismiss];
//    [JYToastUtils showLoading];
    if (showHUD) {
        [JYToastUtils dismiss];
        [JYToastUtils showLoading];
    }
}

- (void)dismissHUD:(BOOL)showHUD
{
//    [JYToastUtils dismiss];
    if (showHUD) {
        [JYToastUtils dismiss];
    }
}
@end
