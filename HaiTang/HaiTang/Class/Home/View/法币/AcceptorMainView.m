//
//  AcceptorMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AcceptorMainView.h"
#import "MarginPopupView.h"
#import "BaseTableViewCell.h"

#import "BaseTableModel.h"
#import "FiatMainViewModel.h"

@interface AcceptorMainView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MarginPopupView *marginPopupView;

@end

@implementation AcceptorMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(FiatMainViewModel *)self.mainViewModel arrayAcceptorTableDatas] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = kFont(14);
    cell.textLabel.textColor = kRGB(16, 16, 16);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor = kRGB(0, 102, 237);
    cell.detailTextLabel.font = kFont(12);
    if (indexPath.row < [[(FiatMainViewModel *)self.mainViewModel arrayAcceptorTableDatas] count]) {
        BaseTableModel *tableModel = [(FiatMainViewModel *)self.mainViewModel arrayAcceptorTableDatas][indexPath.row];
        cell.textLabel.text = NSLocalizedString(tableModel.title, nil);
        cell.detailTextLabel.text = NSLocalizedString(tableModel.subTitle, nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [[(FiatMainViewModel *)self.mainViewModel arrayAcceptorTableDatas] count]) {
        BaseTableModel *tableModel = [(FiatMainViewModel *)self.mainViewModel arrayAcceptorTableDatas][indexPath.row];
        if ([NSString isEmpty:tableModel.subTitle]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectedIndex:)]) {
                [self.delegate performSelector:@selector(tableView:didSelectedIndex:) withObject:tableView withObject:indexPath];
            }
        } else {
            if ([tableModel.subTitle isEqualToString:@"保证金不足"]) {
                //保证金不足
//                [self.marginPopupView showViewWithPopupType:PopupTypeBackUpDeposit];
                if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectedIndex:)]) {
                    [self.delegate performSelector:@selector(tableView:didSelectedIndex:) withObject:tableView withObject:indexPath];
                }
            }
        }
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.tableView = [self setupTableViewWithDelegate:self];
    self.tableView.rowHeight = 45;
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

#pragma mark - Setter & Getter
- (MarginPopupView *)marginPopupView {
    if (!_marginPopupView) {
        _marginPopupView = [[MarginPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _marginPopupView;
}

@end
