//
//  DepthTableView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "DepthTableView.h"
#import "DepthViewCell.h"
#import "DepthSellTableCell.h"

@interface DepthTableView ()

@end

@implementation DepthTableView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    if (indexPath.row < [self.arrayTableDatas count]) {
        if ([self.type isEqualToString:@"BUY"]) {
            cell = [DepthViewCell cellWithTableNibView:tableView];
        } else {
            cell = [DepthSellTableCell cellWithTableNibView:tableView];
        }
        [cell setViewWithModel:self.arrayTableDatas[indexPath.row]];
    }
    return cell;
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.tableView = [self setupTableViewWithDelegate:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 27;
    self.tableView.hidden = NO;
    self.tableView.scrollEnabled = NO;
}

#pragma mark - Setter & Getter
- (void)setArrayTableDatas:(NSArray *)arrayTableDatas {
    if (arrayTableDatas) {
        _arrayTableDatas = arrayTableDatas;
        [self.tableView reloadData];
    }
}

@end
