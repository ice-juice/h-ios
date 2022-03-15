//
//  NoticeListMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NoticeListMainView.h"
#import "NoticeListTableCell.h"
#import "EmptyView.h"

#import "NewModel.h"
#import "HomeMainViewModel.h"

@interface NoticeListMainView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NoticeListMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(HomeMainViewModel *)self.mainViewModel arrayNewDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [[(HomeMainViewModel *)self.mainViewModel arrayNewDatas] count]) {
        NewModel *newModel = [(HomeMainViewModel *)self.mainViewModel arrayNewDatas][indexPath.section];
        return newModel.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeListTableCell *cell = [NoticeListTableCell cellWithTableNibView:tableView];
    if (indexPath.section < [[(HomeMainViewModel *)self.mainViewModel arrayNewDatas] count]) {
        NewModel *newModel = [(HomeMainViewModel *)self.mainViewModel arrayNewDatas][indexPath.section];
        [cell setViewWithModel:newModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < [[(HomeMainViewModel *)self.mainViewModel arrayNewDatas] count]) {
        NewModel *newModel = [(HomeMainViewModel *)self.mainViewModel arrayNewDatas][indexPath.section];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:checkNoticeDetail:)]) {
            [self.delegate performSelector:@selector(tableView:checkNoticeDetail:) withObject:tableView withObject:newModel];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped shouldRefresh:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
    
    self.emptyView = [[EmptyView alloc] initWithSuperView:self.tableView title:@"暂无数据" imageName:@"aqsz-k"];
}

- (void)updateView {
    self.emptyView.hidden = [[(HomeMainViewModel *)self.mainViewModel arrayNewDatas] count];
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

@end
