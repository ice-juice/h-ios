//
//  SelectTimeView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SelectTimeView.h"
#import "SelectTimeTableCell.h"

@interface SelectTimeView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SelectTimeView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectTimeTableCell *cell = [SelectTimeTableCell cellWithTableNibView:tableView];
    if (indexPath.row < [self.arrayTableDatas count]) {
        [cell setViewWithModel:self.arrayTableDatas[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.arrayTableDatas count]) {
        if (self.onSelectRowAtIndex) {
            self.onSelectRowAtIndex(indexPath.row);
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
    
    [self addSubview:self.tableView];
}

- (void)showViewWithX:(CGFloat)x withY:(CGFloat)y {
    CGFloat height = self.arrayTableDatas.count * 29;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.tableView setFrame:CGRectMake(x, y, 60, height)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.tableView setFrame:CGRectMake(x, y, 60, height)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
    if (self.onCloseViewBlock) {
        self.onCloseViewBlock();
    }
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 152, 60, 116)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kRGB(10, 22, 39);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 29;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
