//
//  DropDownView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "DropDownView.h"
#import "DropDownTableCell.h"

@interface DropDownView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DropDownView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropDownTableCell *cell = [DropDownTableCell cellWithTableNibView:tableView];
    if (indexPath.row < [self.arrayTableDatas count]) {
        [cell setViewWithModel:self.arrayTableDatas[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.arrayTableDatas count]) {
        id obj = self.arrayTableDatas[indexPath.row];
        if (self.onDidSelectIndexBlock) {
            self.onDidSelectIndexBlock(obj);
        }
        [self closeView];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.userInteractionEnabled = YES;
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)]];
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 46, 80, 210)];
    self.contentView.backgroundColor = kRGB(235, 242, 252);
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (void)showViewWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(x, y, width, height)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(x, y, width, height)];
    }];
    [self.tableView reloadData];
}

- (void)closeView {
    [self removeFromSuperview];
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 32;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

@end
