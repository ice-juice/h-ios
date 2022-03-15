//
//  BaseTableModel.h
//  BlueLeaf
//
//  Created by XQ on 2019/1/5.
//  Copyright © 2019年 XQ. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableModel : BaseModel

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, strong) id content;

- (instancetype)initWithTitle:(NSString * _Nullable )title;

- (instancetype)initWithImageName:(NSString * _Nullable )imageName;

- (instancetype)initWithImageName:(NSString * _Nullable )imageName title:(NSString * _Nullable )title;

- (instancetype)initWithTitle:(NSString * _Nullable )title subTitle:(NSString * _Nullable )subTitle;

- (instancetype)initWithImageName:(NSString * _Nullable )imageName title:(NSString * _Nullable )title subTitle:(NSString * _Nullable )subTitle;

@end

NS_ASSUME_NONNULL_END
