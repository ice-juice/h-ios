//
//  RecordsMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RecordsMainViewDelegate <BaseMainViewDelegate>
//筛选
- (void)tableViewWithFilter:(UITableView *)tableView;

@end

@interface RecordsMainView : BaseTableView
//更新类型
- (void)updateTypeView;
//更新头部视图
- (void)updateHeaderView;


@end

NS_ASSUME_NONNULL_END
