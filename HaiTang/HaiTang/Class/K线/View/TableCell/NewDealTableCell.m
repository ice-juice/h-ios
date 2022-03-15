//
//  NewDealTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NewDealTableCell.h"
#import "NewDealViewCell.h"

#import "TradeListSubModel.h"

@interface NewDealTableCell ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<TradeListSubModel *> *arrayTableDatas;

@end

@implementation NewDealTableCell
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewDealViewCell *cell = [NewDealViewCell cellWithTableNibView:tableView];
    if (indexPath.row == 0) {
        [cell setViewWithModel:nil];
    } else {
        if (indexPath.row < [self.arrayTableDatas count] + 1) {
            TradeListSubModel *subModel = self.arrayTableDatas[indexPath.row - 1];
            [cell setViewWithModel:subModel];
        }
    }
    
    return cell;
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(3, 14, 30);
    
    [self addSubview:self.tableView];
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

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 32;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


@end
