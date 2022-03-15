//
//  AboutUsMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AboutUsMainView.h"
#import "BaseTableViewCell.h"

@interface AboutUsMainView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AboutUsMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.textLabel.text = @[@"隐私政策", @"服务条款", @"版本号"][indexPath.row];
    if (indexPath.row == 2) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@", appVersion];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectedIndex:)]) {
        [self.delegate performSelector:@selector(tableView:didSelectedIndex:) withObject:tableView withObject:indexPath];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.tableView = [self setupTableViewWithDelegate:self];
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
