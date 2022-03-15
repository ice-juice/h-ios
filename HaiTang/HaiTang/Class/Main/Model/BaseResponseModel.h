//
//  BaseResponseModel.h
//  iShop
//
//  Created by JY on 2018/6/7.
//  Copyright © 2018年 帝辰科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResponseModel : NSObject

@property (nonatomic, copy) NSString *code;    // 返回码: 200成功, 其他为失败
@property (nonatomic, copy) NSString *message; // 返回信息
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) id result;       // 返回内容
@property (nonatomic, strong) id data;         // 返回内容
@property (nonatomic, copy) NSString *error;   // 失败的结果
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSDictionary *pager;

@end
