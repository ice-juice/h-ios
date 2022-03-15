//
//  HomeTableModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableModel : BaseTableModel
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) id content;
@property (nonatomic, assign) HomeTableCellType cellType;

- (instancetype)initWithHomeTableCellType:(HomeTableCellType)cellType;

@end

NS_ASSUME_NONNULL_END
