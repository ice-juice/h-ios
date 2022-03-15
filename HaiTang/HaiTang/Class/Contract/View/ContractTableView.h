//
//  ContractTableView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractTableView : BaseTableView
@property (nonatomic, copy) NSArray *arrayTableDatas;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) CGFloat maxNumber;
@property (nonatomic, copy) NSString *number;

@end

NS_ASSUME_NONNULL_END
