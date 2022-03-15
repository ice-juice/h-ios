//
//  NoticeListMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@class NewModel;

@protocol NoticeListMainViewDelegate <BaseTableViewDelegate>
//查看公告详情
- (void)tableView:(UITableView *)tableView checkNoticeDetail:(NewModel *)newModel;

@end

@interface NoticeListMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
