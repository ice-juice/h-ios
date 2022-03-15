//
//  FiatOrderMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderMainView.h"
#import "FiatOrderTableCell.h"
#import "EmptyView.h"

#import "OrderModel.h"
#import "FiatMainViewModel.h"

@interface FiatOrderMainView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation FiatOrderMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(FiatMainViewModel *)self.mainViewModel arrayMineOrderListDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FiatOrderTableCell *cell = [FiatOrderTableCell cellWithTableNibView:tableView];
    if (indexPath.section < [[(FiatMainViewModel *)self.mainViewModel arrayMineOrderListDatas] count]) {
        OrderModel *orderModel = [(FiatMainViewModel *)self.mainViewModel arrayMineOrderListDatas][indexPath.section];
        [cell setViewWithModel:orderModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < [[(FiatMainViewModel *)self.mainViewModel arrayMineOrderListDatas] count]) {
        OrderModel *orderModel = [(FiatMainViewModel *)self.mainViewModel arrayMineOrderListDatas][indexPath.section];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:checkOrderDetail:pageType:)]) {
            [[NSInvocation invocationWithTarget:self.delegate selector:@selector(tableView:checkOrderDetail:pageType:) params:@[tableView, orderModel.orderNo, orderModel.pageType]] invoke];
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
    self.backgroundColor = kRGB(248, 248, 248);
    
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped shouldRefresh:YES];
    self.tableView.rowHeight = 142;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.emptyView = [[EmptyView alloc] initWithSuperView:self.tableView title:nil imageName:@"fbjy-cds-k"];
}

- (void)updateView {
    self.emptyView.hidden = [[(FiatMainViewModel *)self.mainViewModel arrayMineOrderListDatas] count];
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

@end
