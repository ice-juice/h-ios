//
//  ContractTableViewCell.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractTableViewCell : BaseTableViewCell
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) CGFloat maxNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewWidth;
@property (nonatomic, copy) NSString *number;   //保留小数位数

@end

NS_ASSUME_NONNULL_END
