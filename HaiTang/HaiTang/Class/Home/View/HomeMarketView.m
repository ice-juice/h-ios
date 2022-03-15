//
//  HomeMarketView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2021/2/3.
//  Copyright © 2021 zy. All rights reserved.
//

#import "HomeMarketView.h"
#import "HomeQuotesViewCell.h"

#import "QuotesModel.h"

@interface HomeMarketView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<QuotesModel *> *arrayTableDatas;

@end

@implementation HomeMarketView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeQuotesViewCell *cell = [HomeQuotesViewCell cellWithTableNibView:tableView];
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
        if (self.onCheckKlineBlock) {
            self.onCheckKlineBlock(quotesModel.symbol);
        }
    }
}

#pragma mark - Event Response
- (void)onBtnWithSwitchQuotesEvent:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
    
    NSString *type = index == 0 ? @"1" : @"0";
    if (self.onDidSelectContractOrCoinBlock) {
        self.onDidSelectContractOrCoinBlock(type);
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.arrayBtns) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayBtns removeAllObjects];
    }
    __block CGFloat btnW = 0;
    [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(153, 153, 153) highlightedTitleColor:kRGB(153, 153, 153) font:kFont(16) target:self selector:@selector(onBtnWithSwitchQuotesEvent:)];
        [btn setTitleColor:kRGB(16, 16, 16) forState:UIControlStateSelected];
        btn.tag = idx + 1000;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        CGFloat w = [btn.titleLabel.text widthForFont:kFont(16) maxHeight:30] + 10;
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15);
            make.left.equalTo(15 + btnW);
            make.width.equalTo(w);
            make.height.equalTo(30);
        }];
        [self.arrayBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
        }
        btnW += w;
    }];
    
    UILabel *lbName = [UILabel labelWithText:NSLocalizedString(@"名称", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
    [self addSubview:lbName];
    [lbName makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(60);
    }];
    
    UILabel *lbPrice = [UILabel labelWithText:NSLocalizedString(@"最新价格", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
    [self addSubview:lbPrice];
    [lbPrice makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(lbName);
    }];
    
    UILabel *lbRate = [UILabel labelWithText:NSLocalizedString(@"涨跌幅", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
    [self addSubview:lbRate];
    [lbRate makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(lbPrice);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(85);
        make.left.right.bottom.equalTo(0);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSArray class]]) {
        self.arrayTableDatas = model;
        [self.tableView reloadData];
    }
}

#pragma mark - Setter & Getter
- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayBtns;
}

- (NSArray<NSString *> *)arrayBtnTitles {
    if (!_arrayBtnTitles) {
        _arrayBtnTitles = @[@"合约行情", @"币币指数"];
    }
    return _arrayBtnTitles;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
