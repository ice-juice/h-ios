//
//  DepthTableView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DepthTableView : BaseTableView
@property (nonatomic, strong) NSArray *arrayTableDatas;
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
