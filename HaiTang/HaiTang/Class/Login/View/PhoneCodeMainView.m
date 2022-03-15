//
//  PhoneCodeMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/11.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PhoneCodeMainView.h"
#import "BaseTableViewCell.h"

#import "PhoneCodeModel.h"
#import "LoginMainViewModel.h"

@interface PhoneCodeMainView ()

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation PhoneCodeMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(LoginMainViewModel *)self.mainViewModel arrayPhoneCodeDatas] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    if (indexPath.row < [[(LoginMainViewModel *)self.mainViewModel arrayPhoneCodeDatas] count]) {
        PhoneCodeModel *codeModel = [(LoginMainViewModel *)self.mainViewModel arrayPhoneCodeDatas][indexPath.row];
        cell.textLabel.text = codeModel.code;
        if (indexPath.row == self.selectIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [[(LoginMainViewModel *)self.mainViewModel arrayPhoneCodeDatas] count]) {
        self.selectIndex = indexPath.row;
        PhoneCodeModel *codeModel = [(LoginMainViewModel *)self.mainViewModel arrayPhoneCodeDatas][indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:selectPhoneCode:)]) {
            [self.delegate performSelector:@selector(tableView:selectPhoneCode:) withObject:tableView withObject:codeModel.code];
        }
        [tableView reloadData];
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
