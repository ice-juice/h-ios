//
//  UpdateDealMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/4.
//  Copyright © 2020 zy. All rights reserved.
//

#import "UpdateDealMainView.h"
#import "NewDealViewCell.h"

#import "TradeListSubModel.h"
#import "KLineMainViewModel.h"

@implementation UpdateDealMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(KLineMainViewModel *)self.mainViewModel arrayNewPriceDatas] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewDealViewCell *cell = [NewDealViewCell cellWithTableNibView:tableView];
    if (indexPath.row == 0) {
        [cell setViewWithModel:nil];
    } else {
        if (indexPath.row < [[(KLineMainViewModel *)self.mainViewModel arrayNewPriceDatas] count] + 1) {
            TradeListSubModel *subModel = [(KLineMainViewModel *)self.mainViewModel arrayNewPriceDatas][indexPath.row - 1];
            [cell setViewWithModel:subModel];
        }
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:scrollViewDidScroll:)]) {
        [self.delegate performSelector:@selector(tableView:scrollViewDidScroll:) withObject:self.tableView withObject:scrollView];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(3, 14, 30);
    self.tableView = [self setupTableViewWithDelegate:self];
    self.tableView.rowHeight = 32;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.hidden = NO;
}

- (void)updateView {
    [self.tableView reloadData];
}

@end
