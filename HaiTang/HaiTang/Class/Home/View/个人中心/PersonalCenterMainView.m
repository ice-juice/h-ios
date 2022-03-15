//
//  PersonalCenterMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PersonalCenterMainView.h"
#import "BaseTableViewCell.h"
#import "ExitPopupView.h"

#import "UserModel.h"
#import "BaseTableModel.h"
#import "HomeMainViewModel.h"

@interface PersonalCenterMainView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *lbAccount;
@property (nonatomic, strong) UILabel *lbUid;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) ExitPopupView *exitView;

@property (nonatomic, copy) NSString *uid;

@end

@implementation PersonalCenterMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(HomeMainViewModel *)self.mainViewModel arrayPersonalTableDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [[(HomeMainViewModel *)self.mainViewModel arrayPersonalTableDatas] count]) {
        return [[(HomeMainViewModel *)self.mainViewModel arrayPersonalTableDatas][section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.textLabel.font = kFont(14);
    cell.textLabel.textColor = kRGB(16, 16, 16);
    cell.detailTextLabel.font = kFont(12);
    cell.detailTextLabel.textColor = kRGB(0, 102, 237);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section < [[(HomeMainViewModel *)self.mainViewModel arrayPersonalTableDatas] count]) {
        BaseTableModel *tableModel = [(HomeMainViewModel *)self.mainViewModel arrayPersonalTableDatas][indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:tableModel.imageName];
        cell.textLabel.text = NSLocalizedString(tableModel.title, nil);
        cell.detailTextLabel.text = NSLocalizedString(tableModel.subTitle, nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < [[(HomeMainViewModel *)self.mainViewModel arrayPersonalTableDatas] count]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectedIndex:)]) {
            [self.delegate performSelector:@selector(tableView:didSelectedIndex:) withObject:tableView withObject:indexPath];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

#pragma mark - Event Response
- (void)onBtnWithCopyUIDEvent:(UIButton *)btn {
    //复制UID
    UIPasteboard *myPasteboard = [UIPasteboard generalPasteboard];
    myPasteboard.string = self.uid;
    [JYToastUtils showLongWithStatus:NSLocalizedString(@"复制成功", nil) completionHandle:nil];
}

- (void)onBtnWithExitEvent:(UIButton *)btn {
    //退出
    [self.exitView showView];
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.scrollEnabled = NO;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
}

- (void)updateView {
    UserModel *userModel = [(HomeMainViewModel *)self.mainViewModel userModel];
    if ([userModel.loginMethod isEqualToString:@"PHONE"]) {
        self.lbAccount.text = [userModel.account stringByReplacingString:userModel.phone];
    } else {
        self.lbAccount.text = [userModel.account stringByReplacingString:userModel.email];
    }
        
    self.lbUid.text = [NSString stringWithFormat:@"UID:%@", userModel.uid];
    self.uid = userModel.uid;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - Setter & Getter
- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 93)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        self.lbAccount = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:20]];
        [_tableHeaderView addSubview:self.lbAccount];
        [self.lbAccount makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.equalTo(15);
        }];
        
        self.lbUid = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
        [_tableHeaderView addSubview:self.lbUid];
        [self.lbUid makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lbAccount.mas_bottom).offset(5);
            make.left.equalTo(15);
        }];
        
        UIButton *btnCopy = [UIButton buttonWithImageName:@"dd-fz" highlightedImageName:@"dd-fz" target:self selector:@selector(onBtnWithCopyUIDEvent:)];
        [_tableHeaderView addSubview:btnCopy];
        [btnCopy makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(30);
            make.centerY.equalTo(self.lbUid);
            make.left.equalTo(self.lbUid.mas_right).offset(5);
        }];
    }
    return _tableHeaderView;
}

- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        
        UIButton *btnExit = [UIButton buttonWithTitle:NSLocalizedString(@"退出", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithExitEvent:)];
        btnExit.backgroundColor = kRGB(0, 102, 237);
        btnExit.layer.cornerRadius = 4;
        [_tableFooterView addSubview:btnExit];
        [btnExit makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(40);
            make.left.equalTo(50);
            make.right.equalTo(-50);
            make.height.equalTo(30);
        }];
    }
    return _tableFooterView;
}

- (ExitPopupView *)exitView {
    if (!_exitView) {
        _exitView = [[ExitPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_exitView setOnBtnWithLogoutBlock:^{
            //退出登录
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewWithLogout:)]) {
                [weakSelf.delegate performSelector:@selector(tableViewWithLogout:) withObject:weakSelf.tableView];
            }
        }];
    }
    return _exitView;
}

@end
