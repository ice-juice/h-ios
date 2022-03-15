//
//  UITextField+Category.h
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Category)
/**
 *  创建left view为image的编辑框，主要用于登录注册
 */
- (instancetype)initWithImageName:(NSString *)imageName placeHolder:(NSString *)placeHolder;

- (instancetype)initWithImageName:(NSString *)imageName text:(NSString * _Nullable)text textColor:(UIColor *)textColor placeHolder:(NSString *)placeHolder placeHolderColor:(UIColor *)placeHolderColor font:(UIFont *)font;

- (instancetype)initWithImageName:(NSString *)imageName text:(NSString * _Nullable)text textColor:(UIColor *)textColor placeHolder:(NSString *)placeHolder placeHolderColor:(UIColor *)placeHolderColor font:(UIFont *)font hasLine:(BOOL)hasLine;

/**
 *  创建left view为label的编辑框，主要用于地址管理
 */
- (instancetype)initWithLeftViewText:(NSString *)leftViewText placeHolder:(NSString *)placeHolder;

- (instancetype)initWithLeftViewText:(NSString *)leftViewText placeHolder:(NSString *)placeHolder hasLine:(BOOL)hasLine;

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder;

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder hasLine:(BOOL)hasLine;

- (instancetype)initNoLeftViewWithPlaceHolder:(NSString *)placeHolder hasLine:(BOOL)hasLine;

@end

NS_ASSUME_NONNULL_END
