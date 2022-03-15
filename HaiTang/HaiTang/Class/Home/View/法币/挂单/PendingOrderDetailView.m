//
//  PendingOrderDetailView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PendingOrderDetailView.h"
#import "MarginPopupView.h"
#import "FiatOrderDetailTextCell.h"

#import "OrderModel.h"
#import "FiatMainViewModel.h"
#import "FiatOrderDetailTableModel.h"

@interface PendingOrderDetailView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *lbStatus;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIImageView *imgViewIcon;
@property (nonatomic, strong) UILabel *lbTotal;          //总量
@property (nonatomic, strong) UILabel *lbLumpSum;        //总额
@property (nonatomic, strong) UILabel *lbPrice;           //单价
@property (nonatomic, strong) UILabel *lbNumber;          //剩余数量
@property (nonatomic, strong) UILabel *lbPriceTitle;
@property (nonatomic, strong) UILabel *lbNumberTitle;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *btnCancelOrder;

@property (nonatomic, strong) NSArray<FiatOrderDetailTableModel *> *arrayTableDatas;

@property (nonatomic, copy) NSString *orderType;

@property (nonatomic, strong) MarginPopupView *cancelPopupView;

@end

@implementation PendingOrderDetailView
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"挂单详情", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [view addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(0);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

#pragma mark - Event Response
- (void)onBtnCancelOrderEvent:(UIButton *)btn {
    //撤单
    PopupType popupType = [self.orderType isEqualToString:@"BUY"] ? PopupTypeCancelPendingBuyOrder : PopupTypeCancelPendingSellOrder;
    [self.cancelPopupView showViewWithPopupType:popupType];
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = kRGB(0, 125, 255);
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(152);
    }];
    
    self.imgViewIcon = [[UIImageView alloc] init];
    self.imgViewIcon.contentMode = UIViewContentModeScaleAspectFit;
    [backgroundView addSubview:self.imgViewIcon];
    [self.imgViewIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.right.equalTo(-15);
        make.width.equalTo(127);
        make.height.equalTo(120);
    }];
    
    self.lbStatus = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
    [backgroundView addSubview:self.lbStatus];
    [self.lbStatus makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
    }];
    
    self.lbTitle = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:kBoldFont(12)];
    [backgroundView addSubview:self.lbTitle];
    [self.lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbStatus.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4;
    [self addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(108 + kNavBarHeight);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(126);
    }];
    
    UILabel *lbTotalTitle = [UILabel labelWithText:@"总量：" textColor:kRGB(153, 153, 153) font:kFont(12)];
    [contentView addSubview:lbTotalTitle];
    [lbTotalTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15);
        make.left.equalTo(15);
    }];
    
    self.lbTotal = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [contentView addSubview:self.lbTotal];
    [self.lbTotal makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbTotalTitle);
        make.right.equalTo(-15);
    }];
    
    UILabel *lbLumpSumTitle = [UILabel labelWithText:@"总额：" textColor:kRGB(153, 153, 153) font:kFont(12)];
    [contentView addSubview:lbLumpSumTitle];
    [lbLumpSumTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTotalTitle.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbLumpSum = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [contentView addSubview:self.lbLumpSum];
    [self.lbLumpSum makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbLumpSumTitle);
        make.right.equalTo(-15);
    }];
    
    self.lbPriceTitle = [UILabel labelWithText:@"" textColor:kRGB(153, 153, 153) font:kFont(12)];
    [contentView addSubview:self.lbPriceTitle];
    [self.lbPriceTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbLumpSumTitle.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbPrice = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [contentView addSubview:self.lbPrice];
    [self.lbPrice makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbPriceTitle);
        make.right.equalTo(-15);
    }];
    
    self.lbNumberTitle = [UILabel labelWithText:@"" textColor:kRGB(153, 153, 153) font:kFont(12)];
    [contentView addSubview:self.lbNumberTitle];
    [self.lbNumberTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(-15);
    }];
    
    self.lbNumber = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [contentView addSubview:self.lbNumber];
    [self.lbNumber makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbNumberTitle);
        make.right.equalTo(-15);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(15);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(225);
    }];
    
    self.btnCancelOrder = [UIButton buttonWithTitle:NSLocalizedString(@"撤单", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnCancelOrderEvent:)];
    self.btnCancelOrder.layer.cornerRadius = 4;
    self.btnCancelOrder.backgroundColor = kRGB(0, 102, 237);
    self.btnCancelOrder.hidden = YES;
    [self addSubview:self.btnCancelOrder];
    [self.btnCancelOrder makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

- (void)updateView {
    self.arrayTableDatas = [(FiatMainViewModel *)self.mainViewModel arrayOrderDetailDatas];
    [self.tableView reloadData];
    
    OrderModel *orderModel = [(FiatMainViewModel *)self.mainViewModel orderDetailModel];
    self.orderType = orderModel.pageType;
    if ([orderModel.status isEqualToString:@"Y"]) {
        self.lbStatus.text = NSLocalizedString(@"挂单中", nil);
        self.imgViewIcon.image = [StatusHelper imageNamed:@"wdgd-gdz"];
        self.btnCancelOrder.hidden = NO;
        if ([orderModel.pageType isEqualToString:@"BUY"]) {
            self.lbTitle.text = NSLocalizedString(@"购买USDT 等待卖家出售", nil);
            self.lbPriceTitle.text = NSLocalizedString(@"购买单价：", nil);
            self.lbNumberTitle.text = NSLocalizedString(@"购买数量：", nil);
        } else {
            self.lbTitle.text = NSLocalizedString(@"出售USDT 等待买家购买", nil);
            self.lbPriceTitle.text = NSLocalizedString(@"出售单价：", nil);
            self.lbNumberTitle.text = NSLocalizedString(@"出售数量：", nil);
        }
    } else {
        self.lbStatus.text = NSLocalizedString(@"已撤单", nil);
        self.imgViewIcon.image = [StatusHelper imageNamed:@"wdgd-ycd"];
        self.btnCancelOrder.hidden = YES;
        if ([orderModel.pageType isEqualToString:@"BUY"]) {
            self.lbTitle.text = NSLocalizedString(@"购买USDT 已撤单", nil);
            self.lbPriceTitle.text = NSLocalizedString(@"购买单价：", nil);
            self.lbNumberTitle.text = NSLocalizedString(@"购买数量：", nil);
        } else {
            self.lbTitle.text = NSLocalizedString(@"出售USDT", nil);
            self.lbPriceTitle.text = NSLocalizedString(@"出售单价：", nil);
            self.lbNumberTitle.text = NSLocalizedString(@"出售数量：", nil);
        }
    }
    self.lbTotal.text = [NSString stringWithFormat:@"%.4fUSDT", [orderModel.number floatValue]];
    self.lbLumpSum.text = [NSString stringWithFormat:@"$%.2f", [orderModel.totalPrice floatValue]];
    self.lbPrice.text = [NSString stringWithFormat:@"$%.2f", [orderModel.unitPrice floatValue]];
    self.lbNumber.text = [NSString stringWithFormat:@"%.4fUSDT", [orderModel.restNumber floatValue]];
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

- (MarginPopupView *)cancelPopupView {
    if (!_cancelPopupView) {
        _cancelPopupView = [[MarginPopupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_cancelPopupView setOnBtnWithYesBlock:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(cancelOrder)]) {
                [weakSelf.delegate performSelector:@selector(cancelOrder)];
            }
        }];
    }
    return _cancelPopupView;
}

@end
