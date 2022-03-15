//
//  MyPendingOrderMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "MyPendingOrderMainView.h"
#import "FiatOrderTableCell.h"
#import "EmptyView.h"

#import "OrderModel.h"
#import "FiatMainViewModel.h"

@interface MyPendingOrderMainView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyPendingOrderMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FiatOrderTableCell *cell = [FiatOrderTableCell cellWithTableNibView:tableView];
    if (indexPath.section < [[(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas] count]) {
        OrderModel *orderModel = [(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas][indexPath.section];
        [cell setViewWithModel:orderModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < [[(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas] count]) {
        OrderModel *orderModel = [(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas][indexPath.section];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:checkOrderDetail:)]) {
            [self.delegate performSelector:@selector(tableView:checkOrderDetail:) withObject:tableView withObject:orderModel];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped shouldRefresh:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 142;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
    
    self.emptyView = [[EmptyView alloc] initWithSuperView:self.tableView title:@"无数据" imageName:@"aqsz-k"];
}

- (void)updateView {
    self.emptyView.hidden = [[(FiatMainViewModel *)self.mainViewModel arrayOrderListDatas] count];
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

@end
