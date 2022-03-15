//
//  SelectSymbolMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelectSymbolMainViewDelegate <BaseTableViewDelegate>
//选择币种
- (void)tableView:(UITableView *)tableView selectSymbol:(NSString *)symbol;

@end

@interface SelectSymbolMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
