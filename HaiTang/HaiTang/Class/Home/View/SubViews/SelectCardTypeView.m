//
//  SelectCardTypeView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/22.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SelectCardTypeView.h"
#import "BaseTableViewCell.h"

@interface SelectCardTypeView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *arrayTableDatas;
@end

@implementation SelectCardTypeView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = kRGB(16, 16, 16);
    cell.textLabel.font = kFont(14);
    if (indexPath.row < [self.arrayTableDatas count]) {
        NSString *title = self.arrayTableDatas[indexPath.row];
        cell.textLabel.text = NSLocalizedString(title, nil);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.arrayTableDatas count]) {
        NSString *title = self.arrayTableDatas[indexPath.row];
        if (self.onSelectCardTypeBlock) {
            self.onSelectCardTypeBlock(title);
        }
        [self closeView];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1;
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(77 + kNavBarHeight);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(88);
    }];
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.tableView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth - 30, 88)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.tableView setFrame:CGRectMake(0, kNavBarHeight + 77, kScreenWidth - 30, 88)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray<NSString *> *)arrayTableDatas {
    if (!_arrayTableDatas) {
        _arrayTableDatas = @[@"身份证", @"护照"];
    }
    return _arrayTableDatas;
}

@end
