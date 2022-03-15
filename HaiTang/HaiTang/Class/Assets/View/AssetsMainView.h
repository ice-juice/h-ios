//
//  AssetsMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AssetsMainViewDelegate <BaseTableViewDelegate>
//充币
- (void)tableViewWithCheckRecharge:(UITableView *)tableView;
//提币
- (void)tableViewWithWithdraw:(UITableView *)tableView;
//划转
- (void)tableViewWithTransfer:(UITableView *)tableView;
//资产详情
- (void)tableView:(UITableView *)tableView checkAssetsDetail:(NSString *)list_id;
//切换资产
- (void)tableViewSwitchAssets:(UITableView *)tableView;
//记录
- (void)tableViewWithCheckRecord:(UITableView *)tableView;

@end

@interface AssetsMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
