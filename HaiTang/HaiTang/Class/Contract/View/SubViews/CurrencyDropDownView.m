//
//  CurrencyDropDownView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/27.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CurrencyDropDownView.h"
#import "CurrencyDropDownTableCell.h"

#import "QuotesModel.h"

@interface CurrencyDropDownView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray<QuotesModel *> *arrayTableDatas;

@end

@implementation CurrencyDropDownView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyDropDownTableCell *cell = [CurrencyDropDownTableCell cellWithTableNibView:tableView];
    if (indexPath.row < [self.arrayTableDatas count]) {
        QuotesModel *quotesModel = self.arrayTableDatas[indexPath.row];
        [cell setViewWithModel:quotesModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.arrayTableDatas count]) {
        QuotesModel *quotesModel = self.arrayTableDatas[indexPath.row];
        if (self.onDidSelectSymbolAtIndexBlock) {
            self.onDidSelectSymbolAtIndexBlock(quotesModel.symbol);
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
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(275);
    }];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSArray class]]) {
        self.arrayTableDatas = model;
        [self.tableView reloadData];
    }
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, 275)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, 275)];
    }];
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
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 32;
    }
    return _tableView;
}

@end
