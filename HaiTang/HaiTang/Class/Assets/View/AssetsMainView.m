//
//  AssetsMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AssetsMainView.h"
#import "AssetsTableCell.h"

#import "AssetsModel.h"
#import "AssetsListModel.h"
#import "AssetsMainViewModel.h"

@interface AssetsMainView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *lbUSDT;
@property (nonatomic, strong) UILabel *lbCNY;

@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;

@property (nonatomic, strong) UIButton *btnRecharge;   //充币
@property (nonatomic, strong) UIButton *btnWithdraw;   //提币
@property (nonatomic, strong) UIButton *btnTransfer;   //划转
@property (nonatomic, strong) UIButton *btnRecord;     //记录

@property (nonatomic, copy) NSString *selectedIndex;   //默认钱包

@property (nonatomic, strong) NSArray<AssetsListModel *> *arrayTableDatas;

@property (nonatomic, strong) AssetsModel *assetsModel;

@end

@implementation AssetsMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayTableDatas count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetsTableCell *cell = [AssetsTableCell cellWithTableNibView:tableView];
    if (indexPath.row == 0) {
        [cell setViewWithModel:nil];
    } else {
        if (indexPath.row < [self.arrayTableDatas count] + 1) {
            AssetsListModel *listModel = self.arrayTableDatas[indexPath.row - 1];
            [cell setViewWithModel:listModel];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        if (indexPath.row < [self.arrayTableDatas count] + 1) {
            AssetsListModel *listModel = self.arrayTableDatas[indexPath.row - 1];
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:checkAssetsDetail:)]) {
                [self.delegate performSelector:@selector(tableView:checkAssetsDetail:) withObject:tableView withObject:listModel.list_id];
            }
        }
    }
}

#pragma mark - Event Response
- (void)onBtnWithSeenPasswordEvent:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.lbUSDT.text = @"********** USDT";
        self.lbCNY.text = @"≈$********";
    } else {
        self.lbUSDT.text = [NSString stringWithFormat:@"%.8f USDT", [self.assetsModel.valuationTotalPrice doubleValue]];
        self.lbCNY.text = [NSString stringWithFormat:@"≈$%.2f", [self.assetsModel.cny doubleValue]];
    }
}

- (void)onBtnWithSwitchEvent:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.selected = YES;
            obj.titleLabel.font = kBoldFont(18);
        } else {
            obj.selected = NO;
            obj.titleLabel.font = kFont(14);
        }
    }];
    self.selectedIndex = [NSString stringWithFormat:@"%ld", index];
    [(AssetsMainViewModel *)self.mainViewModel setUsdtAssetsType:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewSwitchAssets:)]) {
        [self.delegate performSelector:@selector(tableViewSwitchAssets:) withObject:self.tableView];
    }
}

- (void)onBtnWithRechargeEvent:(UIButton *)btn {
    //充币
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithCheckRecharge:)]) {
        [self.delegate performSelector:@selector(tableViewWithCheckRecharge:) withObject:self.tableView];
    }
}

- (void)onBtnWithWithdrawEvent:(UIButton *)btn {
    //提币
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithWithdraw:)]) {
        [self.delegate performSelector:@selector(tableViewWithWithdraw:) withObject:self.tableView];
    }
}

- (void)onBtnWithTransferEvent:(UIButton *)btn {
    //划转
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithTransfer:)]) {
        [self.delegate performSelector:@selector(tableViewWithTransfer:) withObject:self.tableView];
    }
}

- (void)onBtnWithRecordEvent:(UIButton *)btn {
    //记录
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithCheckRecord:)]) {
        [self.delegate performSelector:@selector(tableViewWithCheckRecord:) withObject:self.tableView];
    }
}

#pragma makr - Super Class
- (void)setupSubViews {    
    [self addSubview:self.headerView];
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(257);
    }];
    
    self.tableView = [self setupTableViewWithDelegate:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 257);
    }];
    
    self.selectedIndex = @"";
}

- (void)updateView {
    self.assetsModel = [(AssetsMainViewModel *)self.mainViewModel assetsModel];
    self.lbUSDT.text = [NSString stringWithFormat:@"%.8f USDT", [self.assetsModel.valuationTotalPrice doubleValue]];
    self.lbCNY.text = [NSString stringWithFormat:@"≈$%.2f", [self.assetsModel.cny doubleValue]];
    self.arrayTableDatas = self.assetsModel.list;
    USDTAssetsType assetsType = [(AssetsMainViewModel *)self.mainViewModel usdtAssetsType];
    if (assetsType == USDTAssetsTypeWallet) {
        self.btnRecharge.hidden = NO;
        self.btnWithdraw.hidden = NO;
        [self.btnTransfer updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kScreenWidth * 0.5);
        }];
    } else {
        self.btnRecharge.hidden = YES;
        self.btnWithdraw.hidden = YES;
        [self.btnTransfer updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
        }];
    }
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - Setter & Getter
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 257)];
        _headerView.backgroundColor = kRGB(248, 248, 248);
        
        UIImageView *imgViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grzc-bg"]];
        [_headerView addSubview:imgViewBackground];
        [imgViewBackground makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.right.equalTo(0);
            make.height.equalTo(100);
        }];
        
        UILabel *lbAssetsTitle = [UILabel labelWithText:NSLocalizedString(@"资产估值", nil) textColor:[UIColor whiteColor] font:kFont(14)];
        [_headerView addSubview:lbAssetsTitle];
        [lbAssetsTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(35);
            make.left.equalTo(15);
        }];
        
        UIButton *btnSeen = [UIButton buttonWithImageName:@"grzc-kj" highlightedImageName:@"grzc-kj" target:self selector:@selector(onBtnWithSeenPasswordEvent:)];
        [btnSeen setImage:[UIImage imageNamed:@"grzc-bkj"] forState:UIControlStateSelected];
        [_headerView addSubview:btnSeen];
        [btnSeen makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(30);
            make.centerY.equalTo(lbAssetsTitle);
            make.left.equalTo(lbAssetsTitle.mas_right).offset(5);
        }];
        
        self.lbUSDT = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:kBoldFont(18)];
        [_headerView addSubview:self.lbUSDT];
        [self.lbUSDT makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbAssetsTitle.mas_bottom).offset(5);
            make.left.equalTo(15);
        }];
        
        self.lbCNY = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:kBoldFont(12)];
        [_headerView addSubview:self.lbCNY];
        [self.lbCNY makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lbUSDT.mas_bottom).offset(5);
            make.left.equalTo(15);
        }];
        if (self.arrayBtns) {
            [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self.arrayBtns removeAllObjects];
        }
        //保存前一个btn的宽度及前一个button距离屏幕边缘的距离
        __block CGFloat btnW = 0;
        [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(14) target:self selector:@selector(onBtnWithSwitchEvent:)];
            [btn setTitleColor:kRGB(0, 102, 237) forState:UIControlStateSelected];
            btn.tag = 1000 + idx;
            
            CGFloat w = [btn.titleLabel.text widthForFont:kBoldFont(18)] + 10;
            btn.frame = CGRectMake(15 + btnW, 140, w, 25);
            btnW += w + 5;
            
            [_headerView addSubview:btn];
            [self.arrayBtns addObject:btn];
            if (idx == 0) {
                btn.selected = YES;
                btn.titleLabel.font = kBoldFont(18);
            }
        }];
        
        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:whiteView];
        [whiteView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(175);
            make.left.right.equalTo(0);
            make.height.equalTo(82);
        }];
        
        self.btnRecharge = [UIButton buttonWithTitle:NSLocalizedString(@"充币", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithRechargeEvent:)];
        [self.btnRecharge setImage:[UIImage imageNamed:@"cb"] forState:UIControlStateNormal];
        [whiteView addSubview:self.btnRecharge];
        [self.btnRecharge makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(0);
            make.width.equalTo(kScreenWidth / 4);
        }];
        [self.btnRecharge setTitleDownSpace:7.5];
        
        self.btnWithdraw = [UIButton buttonWithTitle:NSLocalizedString(@"提币", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithWithdrawEvent:)];
        [self.btnWithdraw setImage:[UIImage imageNamed:@"tb"] forState:UIControlStateNormal];
        [whiteView addSubview:self.btnWithdraw];
        [self.btnWithdraw makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.width.equalTo(kScreenWidth / 4);
            make.left.equalTo(self.btnRecharge.mas_right);
        }];
        [self.btnWithdraw setTitleDownSpace:7.5];
        
        self.btnTransfer = [UIButton buttonWithTitle:NSLocalizedString(@"划转", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithTransferEvent:)];
        [self.btnTransfer setImage:[UIImage imageNamed:@"cb"] forState:UIControlStateNormal];
        [whiteView addSubview:self.btnTransfer];
        [self.btnTransfer makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.width.equalTo(kScreenWidth / 4);
            make.left.equalTo(kScreenWidth * 0.5);
        }];
        [self.btnTransfer setTitleDownSpace:7.5];
        
        self.btnRecord = [UIButton buttonWithTitle:NSLocalizedString(@"记录", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithRecordEvent:)];
        [self.btnRecord setImage:[UIImage imageNamed:@"cb"] forState:UIControlStateNormal];
        [whiteView addSubview:self.btnRecord];
        [self.btnRecord makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.width.equalTo(kScreenWidth / 4);
            make.left.equalTo(self.btnTransfer.mas_right);
        }];
        [self.btnRecord setTitleDownSpace:7.5];
    }
    return _headerView;
}

- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:4];
    }
    return _arrayBtns;
}

- (NSArray<NSString *> *)arrayBtnTitles {
    if (!_arrayBtnTitles) {
        _arrayBtnTitles = @[@"钱包", @"合约", @"币币", @"法币"];
    }
    return _arrayBtnTitles;
}

@end
