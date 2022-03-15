//
//  DepthMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/4.
//  Copyright © 2020 zy. All rights reserved.
//

#import "DepthMainView.h"
#import "DepthTableCell.h"

#import "KLineMainViewModel.h"

@interface DepthMainView ()
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation DepthMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DepthTableCell *cell = [DepthTableCell cellWithTableView:tableView];
    if ([(KLineMainViewModel *)self.mainViewModel tradeListModel]) {
        [cell setViewWithModel:[(KLineMainViewModel *)self.mainViewModel tradeListModel]];
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:scrollViewDidScroll:)]) {
        [self.delegate performSelector:@selector(tableView:scrollViewDidScroll:) withObject:self.tableView withObject:scrollView];
    }
}

#pragma mark - Setter & Getter
- (void)setupSubViews {
    self.backgroundColor = kRGB(3, 14, 30);
    
    self.tableView = [self setupTableViewWithDelegate:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 685;
    self.tableView.hidden = NO;
}

- (void)updateView {
    [self.tableView reloadData];
}

@end
