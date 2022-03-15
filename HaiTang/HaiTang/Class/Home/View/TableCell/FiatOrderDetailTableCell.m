//
//  FiatOrderDetailTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderDetailTableCell.h"
#import "FiatOrderDetailTextCell.h"

#import "FiatOrderDetailTableModel.h"

@interface FiatOrderDetailTableCell ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<FiatOrderDetailTableModel *> *arrayTableDatas;

@end

@implementation FiatOrderDetailTableCell
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FiatOrderDetailTextCell *cell = [FiatOrderDetailTextCell cellWithTableNibView:tableView];
    if (indexPath.row < [self.arrayTableDatas count]) {
        FiatOrderDetailTableModel *tableModel = self.arrayTableDatas[indexPath.row];
        [cell setViewWithModel:tableModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.arrayTableDatas count]) {
        FiatOrderDetailTableModel *tableModel = self.arrayTableDatas[indexPath.row];
        if (tableModel.cellType == FiatOrderDetailCellTypeArrow) {
            NSString *type = [tableModel.title containsString:@"我的"] ? @"0" : @"1";
            if (self.onCheckAppealDetailBlock) {
                self.onCheckAppealDetailBlock(type);
            }
        } else if (tableModel.cellType == FiatOrderDetailCellTypeImage) {
            if (self.onCheckQRCodeImageBlock) {
                self.onCheckQRCodeImageBlock();
            }
        }
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4;
    [self.contentView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"订单详情", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.left.equalTo(15);
    }];
    
    [contentView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(45);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-5);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSMutableArray class]]) {
        self.arrayTableDatas = model;
        [self.tableView reloadData];
    }
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 45;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
