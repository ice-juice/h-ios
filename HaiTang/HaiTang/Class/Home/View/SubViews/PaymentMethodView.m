//
//  PaymentMethodView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/29.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PaymentMethodView.h"
#import "PaymentMethodTableCell.h"

#import "NewModel.h"
#import "BaseTableModel.h"
#import "PaymentMethodModel.h"

@interface PaymentMethodView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<BaseTableModel *> *arrayTableDatas;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, copy) NSString *paymentId;

@end

@implementation PaymentMethodView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrayTableDatas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentMethodTableCell *cell = [PaymentMethodTableCell cellWithTableNibView:tableView];
    if (indexPath.section < [self.arrayTableDatas count]) {
        BaseTableModel *tableModel = self.arrayTableDatas[indexPath.section];
        NewModel *newModel = tableModel.content[indexPath.row];
        cell.isSelected = [self.selectIndexPath isEqual:indexPath] ? YES : NO;
        [cell setViewWithModel:newModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < [self.arrayTableDatas count]) {
        if (![self.selectIndexPath isEqual:indexPath]) {
            self.selectIndexPath = indexPath;
            BaseTableModel *tableModel = self.arrayTableDatas[indexPath.section];
            NewModel *newModel = tableModel.content[indexPath.row];
            self.paymentId = newModel.paymentId;
        }
        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    if (section < [self.arrayTableDatas count]) {
        BaseTableModel *tableModel = self.arrayTableDatas[section];
        UILabel *lbTitle = [UILabel labelWithText:tableModel.title textColor:kRGB(16, 16, 16) font:kFont(14)];
        [view addSubview:lbTitle];
        [lbTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.equalTo(15);
        }];
    }
    return view;
}

#pragma mark - Event Response
- (void)onBtnCloseEvent:(UIButton *)btn {
    [self closeView];
}

- (void)onBtnSureEvent:(UIButton *)btn {
    if ([NSString isEmpty:self.paymentId]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请选择收款账号", nil) duration:2];
    }
    
    BaseTableModel *tableModel = self.arrayTableDatas[self.selectIndexPath.section];
    
    if ([tableModel.title isEqualToString:@"支付宝"]) {
        if (![self.paymentMethod isEqualToString:@"ALI_PAY"]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"只可选择指定的收付款方式", nil) duration:2];
        }
    } else if ([tableModel.title isEqualToString:@"银行卡"]) {
        if (![self.paymentMethod isEqualToString:@"BANK"]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"只可选择指定的收付款方式", nil) duration:2];
        }
    } else if ([tableModel.title isEqualToString:@"PayPal"]) {
        if (![self.paymentMethod isEqualToString:@"PAYPAL"]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"只可选择指定的收付款方式", nil) duration:2];
        }
    } else if ([tableModel.title isEqualToString:@"微信"]) {
        if (![self.paymentMethod isEqualToString:@"WE_CHAT"]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"只可选择指定的收付款方式", nil) duration:2];
        }
    }
    
    if (self.didSelectPaymentAccountBlock) {
        self.didSelectPaymentAccountBlock(self.paymentId);
    }
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
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12;
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(535);
        make.bottom.equalTo(15);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"请选择收款账号", nil) textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:20]];
    [self.contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(24);
        make.left.equalTo(15);
    }];
    
    UIButton *btnClose = [UIButton buttonWithImageName:@"belvedere_ic_close" highlightedImageName:@"belvedere_ic_close" target:self selector:@selector(onBtnCloseEvent:)];
    [self.contentView addSubview:btnClose];
    [btnClose makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(36);
        make.right.equalTo(-15);
        make.top.equalTo(20);
    }];
    
    UILabel *lbSubTitle = [UILabel labelWithText:NSLocalizedString(@"选定账号将接收买方转账", nil) textColor:kRGB(205, 61, 88) font:kBoldFont(12)];
    [self.contentView addSubview:lbSubTitle];
    [lbSubTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(8);
        make.left.equalTo(lbTitle);
    }];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbSubTitle);
        make.left.right.equalTo(0);
        make.height.equalTo(330);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithTitle:NSLocalizedString(@"取消", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnCloseEvent:)];
    btnCancel.layer.cornerRadius = 2;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = kRGB(0, 102, 237).CGColor;
    [self.contentView addSubview:btnCancel];
    [btnCancel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-49);
        make.left.equalTo(15);
        make.width.equalTo(160);
        make.height.equalTo(34);
    }];
    
    UIButton *btnSure = [UIButton buttonWithTitle:NSLocalizedString(@"确认", nil) titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(255, 255, 255) font:kFont(14) target:self selector:@selector(onBtnSureEvent:)];
    btnSure.layer.cornerRadius = 2;
    btnSure.backgroundColor = kRGB(0, 102, 237);
    [self.contentView addSubview:btnSure];
    [btnSure makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-49);
        make.right.equalTo(-15);
        make.width.equalTo(160);
        make.height.equalTo(34);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSMutableArray class]]) {
        self.arrayTableDatas = model;
        [self.tableView reloadData];
    }
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 520)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, kScreenHeight - 520, kScreenWidth, 520)];
    }];
    
    self.paymentId = @"";
    
    self.selectIndexPath = 0;
    [self.tableView reloadData];
}

- (void)closeView {
    [self removeFromSuperview];
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end

