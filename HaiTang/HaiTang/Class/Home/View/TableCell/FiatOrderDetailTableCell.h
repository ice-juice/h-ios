//
//  FiatOrderDetailTableCell.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FiatOrderDetailTableCell : BaseTableViewCell
//查看申诉详情
@property (nonatomic, copy) void (^onCheckAppealDetailBlock)(NSString *type);
//查看二维码
@property (nonatomic, copy) void (^onCheckQRCodeImageBlock)(void);

@end

NS_ASSUME_NONNULL_END
