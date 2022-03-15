//
//  USDTAssetsMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol USDTAssetsMainViewDelegate <BaseTableViewDelegate>
//充币
- (void)tableViewWithCheckRecharge:(UITableView *)tableView;
//提币
- (void)tableViewWithCheckWithdraw:(UITableView *)tableView;
//资产划转
- (void)tableViewWithCheckTransfer:(UITableView *)tableView;
//资产记录
- (void)tableViewWithCheckRecord:(UITableView *)tableView;

@end

@interface USDTAssetsMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
