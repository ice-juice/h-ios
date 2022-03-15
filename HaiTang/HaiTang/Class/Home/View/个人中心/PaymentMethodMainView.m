//
//  PaymentMethodMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PaymentMethodMainView.h"
#import "BaseTableViewCell.h"

#import "PaymentTableModel.h"
#import "HomeMainViewModel.h"

@interface PaymentMethodMainView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PaymentMethodMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(HomeMainViewModel *)self.mainViewModel arrayPaymentTableDatas] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    if (indexPath.row < [[(HomeMainViewModel *)self.mainViewModel arrayPaymentTableDatas] count]) {
        PaymentTableModel *tableModel = [(HomeMainViewModel *)self.mainViewModel arrayPaymentTableDatas][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:tableModel.imageName];
        cell.textLabel.text = NSLocalizedString(tableModel.title, nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [[(HomeMainViewModel *)self.mainViewModel arrayPaymentTableDatas] count]) {
        PaymentTableModel *tableModel = [(HomeMainViewModel *)self.mainViewModel arrayPaymentTableDatas][indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:addPayment:)]) {
            [self.delegate performSelector:@selector(tableView:addPayment:) withObject:tableView withObject:tableModel];
        }
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
