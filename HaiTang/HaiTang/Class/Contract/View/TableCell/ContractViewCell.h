//
//  ContractViewCell.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractViewCell : BaseTableViewCell
//撤销委托
@property (nonatomic, copy) void (^onBtnCancelContractBlock)(NSString *compactId);

@end

NS_ASSUME_NONNULL_END
