//
//  IntroductionMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/4.
//  Copyright © 2020 zy. All rights reserved.
//

#import "IntroductionMainView.h"
#import "IntroductionTableCell.h"

#import "KLineMainViewModel.h"

@implementation IntroductionMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntroductionTableCell *cell = [IntroductionTableCell cellWithTableView:tableView];
    if ([(KLineMainViewModel *)self.mainViewModel introductionModel]) {
        [cell setViewWithModel:[(KLineMainViewModel *)self.mainViewModel introductionModel]];
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
    self.tableView.rowHeight = 600;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.hidden = NO;
}

- (void)updateView {
    [self.tableView reloadData];
}

@end
