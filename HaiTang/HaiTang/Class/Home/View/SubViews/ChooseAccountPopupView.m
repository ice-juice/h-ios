//
//  ChooseAccountPopupView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/30.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ChooseAccountPopupView.h"
#import "BaseTableViewCell.h"

#import "NewModel.h"

@interface ChooseAccountPopupView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray<NewModel *> *arrayTableDatas;

@end

@implementation ChooseAccountPopupView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row < [self.arrayTableDatas count]) {
        NewModel *newModel = self.arrayTableDatas[indexPath.row];
        cell.textLabel.text = newModel.idcard;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.arrayTableDatas count]) {
        NewModel *newModel = self.arrayTableDatas[indexPath.row];
        if (self.didSelectAccountAtIndexBlock) {
            self.didSelectAccountAtIndexBlock(newModel);
        }
        [self closeView];
    }
}

#pragma mark - Event Response
- (void)onBtnCancelEvent:(UIButton *)btn {
    [self closeView];
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = .1;
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 194, kScreenWidth, 194)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12;
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.bottom.equalTo(-99);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithTitle:NSLocalizedString(@"取消", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kBoldFont(14) target:self selector:@selector(onBtnCancelEvent:)];
    [self.contentView addSubview:btnCancel];
    [btnCancel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(45);
    }];
    
    UIView *lineView0 = [[UIView alloc] init];
    lineView0.backgroundColor = kRGB(236, 236, 236);
    [self.contentView addSubview:lineView0];
    [lineView0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnCancel.mas_bottom);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSArray class]]) {
        self.arrayTableDatas = model;
        [self.tableView reloadData];
        [self showView];
    }
}

- (void)showView {
    CGFloat height = [self.arrayTableDatas count] * 50 + 99;
    
    if (height > kScreenHeight * 0.8) {
        height = kScreenHeight * 0.8;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, height)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, kScreenHeight - height, kScreenWidth, height)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

@end
