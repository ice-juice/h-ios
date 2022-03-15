//
//  SecuritySettingsTableModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecuritySettingsTableModel : BaseTableModel
@property (nonatomic, copy) NSString *isBinding;         //是否已绑定 Y-已绑定 N-未绑

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle isBinding:(NSString *)isBinding;

@end

NS_ASSUME_NONNULL_END
