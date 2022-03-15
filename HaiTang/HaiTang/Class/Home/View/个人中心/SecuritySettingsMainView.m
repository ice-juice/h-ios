//
//  SecuritySettingsMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SecuritySettingsMainView.h"
#import "BaseTableViewCell.h"

#import "HomeMainViewModel.h"
#import "SecuritySettingsTableModel.h"

@interface SecuritySettingsMainView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SecuritySettingsMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(HomeMainViewModel *)self.mainViewModel arraySecurityTableDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [[(HomeMainViewModel *)self.mainViewModel arraySecurityTableDatas] count]) {
        NSArray *array = [(HomeMainViewModel *)self.mainViewModel arraySecurityTableDatas][section];
        return [array count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.textLabel.textColor = kRGB(16, 16, 16);
    cell.textLabel.font = kFont(14);
    cell.detailTextLabel.textColor = kRGB(0, 102, 237);
    cell.detailTextLabel.font = kFont(12);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section < [[(HomeMainViewModel *)self.mainViewModel arraySecurityTableDatas] count]) {
        SecuritySettingsTableModel *tableModel = [(HomeMainViewModel *)self.mainViewModel arraySecurityTableDatas][indexPath.section][indexPath.row];
        cell.textLabel.text = tableModel.title;
        cell.detailTextLabel.text = tableModel.subTitle;
        if ([tableModel.isBinding isEqualToString:@"Y"]) {
            cell.detailTextLabel.textColor = kRGB(16, 16, 16);
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < [[(HomeMainViewModel *)self.mainViewModel arraySecurityTableDatas] count]) {
        SecuritySettingsTableModel *tableModel = [(HomeMainViewModel *)self.mainViewModel arraySecurityTableDatas][indexPath.section][indexPath.row];
        if (![tableModel.isBinding isEqualToString:@"Y"]) {
            //已经绑定
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectedIndex:)]) {
                [self.delegate performSelector:@selector(tableView:didSelectedIndex:) withObject:tableView withObject:indexPath];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 60;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"交易设置", nil) textColor:kRGB(0, 102, 237) font:kFont(12)];
    [view addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(-10);
    }];
    
    return view;
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
}

- (void)updateView {
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

@end
