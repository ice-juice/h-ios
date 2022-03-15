//
//  PersonalCenterMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PersonalCenterMainViewDelegate <BaseTableViewDelegate>
//退出登录
- (void)tableViewWithLogout:(UITableView *)tableView;


@end

@interface PersonalCenterMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
