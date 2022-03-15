//
//  FiatOrderDetailTableModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FiatOrderDetailTableModel : BaseTableModel

@property (nonatomic, assign) FiatOrderDetailCellType cellType;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle cellType:(FiatOrderDetailCellType)cellType;

@end

NS_ASSUME_NONNULL_END
