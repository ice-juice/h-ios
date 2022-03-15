//
//  ContractTableView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ContractTableView.h"
#import "ContractTableViewCell.h"

@interface ContractTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ContractTableView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContractTableViewCell *cell = [ContractTableViewCell cellWithTableView:tableView];
    if (indexPath.row < [self.arrayTableDatas count]) {
        cell.maxNumber = self.maxNumber;
        cell.type = self.type;
        cell.number = self.number;
        [cell setViewWithModel:self.arrayTableDatas[indexPath.row]];
    }
    return cell;
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.tableView = [self setupTableViewWithDelegate:self];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 26;
    self.tableView.hidden = NO;
}

- (void)setArrayTableDatas:(NSArray *)arrayTableDatas {
    if (arrayTableDatas) {
        _arrayTableDatas = arrayTableDatas;
        [self.tableView reloadData];
    }
}

@end
