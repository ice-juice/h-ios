//
//  ContractTableHeaderView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ContractTableHeaderView.h"
#import "ContractTableView.h"
#import "LeverageCollectionCell.h"

#import "Service.h"
#import "SymbolModel.h"
#import "QuotesModel.h"
#import "TradeListModel.h"
#import "LeverageListModel.h"

@interface ContractTableHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayPriceBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayPriceBtnTitles;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayPercentBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayPercentBtnTitles;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayCurrentBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayCurrentBtnTitles;

@property (nonatomic, strong) UILabel *lbFull;     //全仓倍数
@property (nonatomic, strong) UILabel *lbLotValue; //一手价值
@property (nonatomic, strong) UILabel *lbLot;      //手数
@property (nonatomic, strong) UITextField *tfLot;
@property (nonatomic, strong) UILabel *lbUSDT;     //委托占用
@property (nonatomic, strong) UILabel *lbMargin;   //仓位保证金
@property (nonatomic, strong) UILabel *lbFee;      //手续费
@property (nonatomic, strong) UILabel *lbAvailable;//可用余额
@property (nonatomic, strong) UILabel *lbNewPrice; //最新行情价
@property (nonatomic, strong) UILabel *lbRate;     //涨跌幅
@property (nonatomic, strong) UILabel *lbPriceTitle;
@property (nonatomic, strong) UITextField *tfPrice;//委托价格
@property (nonatomic, strong) UIButton *btnAll;    //全部
@property (nonatomic, strong) UIButton *btnCurrent;//当前合约
@property (nonatomic, strong) ContractTableView *sellTableView;
@property (nonatomic, strong) ContractTableView *buyTableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<LeverageListModel *> *arrayCollectionDatas;

@property (nonatomic, assign) NSInteger lotValue;     //一手价值
@property (nonatomic, assign) CGFloat feeRatio;       //手续费率
@property (nonatomic, assign) NSInteger selectIndex;  //0-市价 1-限价
@property (nonatomic, assign) CGFloat leverageValue;  //全仓倍数（默认100）
@property (nonatomic, assign) CGFloat percentValue;   //选中的百分比值
@property (nonatomic, assign) CGFloat availableBalance;//可用余额

//选中倍率
@property (nonatomic, assign) NSInteger selectLeverageIndex;

@property (nonatomic, strong) NSTimer *timer;
//交易对
@property (nonatomic, copy) NSString *symbols;
//币种
@property (nonatomic, copy) NSString *coin;

@end

@implementation ContractTableHeaderView
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrayCollectionDatas count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LeverageCollectionCell *cell = [LeverageCollectionCell cellWithNibCollectionView:collectionView withIndexPath:indexPath];
    if (indexPath.item < [self.arrayCollectionDatas count]) {
        LeverageListModel *listModel = self.arrayCollectionDatas[indexPath.item];
        if (indexPath.item == self.selectLeverageIndex) {
            cell.isSelect = YES;
        } else {
            cell.isSelect = NO;
        }
        [cell setViewWithModel:listModel];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item < [self.arrayCollectionDatas count]) {
        LeverageListModel *listModel = self.arrayCollectionDatas[indexPath.item];
        self.selectLeverageIndex = indexPath.item;
        self.lbFull.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"全仓倍数", nil), listModel.name];
        NSString *leverageValue = [listModel.name substringToIndex:listModel.name.length - 1];
        self.leverageValue = [leverageValue floatValue];
        [self calculationLotValue];
        [collectionView reloadData];
    }
}

- (void)calculation {
    //计算值
    CGFloat price = 0;
    if (self.selectIndex == 0) {
        //市价 = 最新行情价
        price = [self.lbNewPrice.text floatValue];
    } else {
        //限价 = 输入委托价
        price = [self.tfPrice.text floatValue];
    }
    //仓位保证金 = 手数 * 每手价值数量 * 委托价格 / 杠杆倍数
    CGFloat margin = [self.tfLot.text floatValue] * self.lotValue * price / self.leverageValue;
    //手续费 = 手数 * 每手价值数量 * 委托价格 * 开仓手续费率
    CGFloat fee = [self.tfLot.text floatValue] * self.lotValue * price * self.feeRatio;
    //委托占用 = 仓位保证金 + 开仓手续费
    CGFloat usdt = margin + fee;
    
    self.lbUSDT.text = [NSString stringWithFormat:@"%.8f USDT", usdt];
    self.lbMargin.text = [NSString stringWithFormat:@"%.8f", margin];
    self.lbFee.text = [NSString stringWithFormat:@"%.8f", fee];
}

- (void)calculationLotValue {
    //填入手数 = (可用余额 * 比例 * 杠杆) / （委托价格 * 每手价值数量 + 委托价格 * 每手价值数量 * 开仓手续费率 * 杠杆）
    CGFloat price = 0.00;
    if (self.selectIndex == 0) {
        //市价 = 最新行情价
        price = [self.lbNewPrice.text floatValue];
    } else {
        //限价 = 输入委托价
        price = [self.tfPrice.text floatValue];
    }
    CGFloat lot = (self.availableBalance * self.percentValue * self.leverageValue) / (price * self.lotValue + price * self.lotValue * self.feeRatio * self.leverageValue);
    if (isnan(lot)) {
        lot = 0.00;
    }
    if (isinf(lot)) {
        lot = 0.00;
    }
    if (lot < 0.00) {
        lot = 0.00;
    }
    
    NSInteger lotInt = roundf(lot);
    
    self.tfLot.text = [NSString stringWithFormat:@"%ld", (long)lotInt];
    
    [self calculation];
}

#pragma mark - Event Response
- (void)onBtnWithSelectPriceEvent:(UIButton *)btn {
    //市价、限价
    if (btn.selected) {
        return;
    }
    self.selectIndex = btn.tag - 1000;
    [self.arrayPriceBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.selectIndex == idx) {
            obj.selected = YES;
            obj.backgroundColor = kRGB(68, 188, 167);
        } else {
            obj.selected = NO;
            obj.backgroundColor = [UIColor clearColor];
        }
    }];
    self.lbPriceTitle.hidden = !self.selectIndex;
    self.tfPrice.hidden = !self.selectIndex;
    CGFloat topHeight = self.selectIndex == 0 ? 45 : 92;
    [self.lbLotValue updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbFull.mas_bottom).offset(topHeight);
    }];
//    [self calculationLotValue];
    [self updateView];
    
    if (self.onBtnWithSelectPriceBlock) {
        self.onBtnWithSelectPriceBlock(self.selectIndex);
    }
}

- (void)onBtnWithSelectPercentEvent:(UIButton *)btn {
    //百分比
    NSInteger index = btn.tag - 3000;
    __block NSString *value = @"0.00";
    NSArray *percentValueArray = @[@"0.25", @"0.50", @"0.75", @"1.00"];
    [self.arrayPercentBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = !obj.selected;
            if (obj.selected) {
                obj.backgroundColor = kRGB(68, 188, 167);
                obj.selected = YES;
                value = percentValueArray[idx];
            } else {
                obj.backgroundColor = [UIColor clearColor];
                obj.selected = NO;
                value = @"0.00";
            }
        } else {
            obj.selected = NO;
            obj.backgroundColor = [UIColor clearColor];
        }
    }];
    self.percentValue = [value floatValue];
    [self calculationLotValue];
}

- (void)onBtnLessEvent:(UIButton *)btn {
    //减
    NSInteger index = [self.tfLot.text integerValue];
    if (index == 0) {
        index = 0;
    } else {
        index -= 1;
    }
    self.tfLot.text = [NSString stringWithFormat:@"%ld", (long)index];
    
    [self calculation];
}

- (void)onBtnAddEvent:(UIButton *)btn {
    //加
    NSInteger index = [self.tfLot.text integerValue];
    index += 1;
    self.tfLot.text = [NSString stringWithFormat:@"%ld", (long)index];
    [self calculation];
}

- (void)onBtnBuyEvent:(UIButton *)btn {
    //买入
    [self submitOrder:@"BUY"];
}

- (void)onBtnSellEvent:(UIButton *)btn {
    //卖出
    [self submitOrder:@"SELL"];
}

- (void)submitOrder:(NSString *)type {
    //下单
    NSString *price = @"";
    if (self.selectIndex == 0) {
        //市价 = 最新行情价
        price = self.lbNewPrice.text;
    } else {
        //限价 = 输入委托价
        price = self.tfPrice.text;
        if ([NSString isEmpty:price] || [price isEqualToString:@"0"]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入委托价格", nil) duration:2];
        }
    }
    
    if ([NSString isEmpty:self.tfLot.text] || [self.tfLot.text isEqualToString:@"0"]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入手数", nil) duration:2];
    }
    
    LeverageListModel *listModel = self.arrayCollectionDatas[self.selectLeverageIndex];
    if (self.onSubmitOrderBlock) {
        self.onSubmitOrderBlock(price, self.tfLot.text, type, listModel.leverage_id);
    }
}

- (void)onBtnWithSelectCurrentEvent:(UIButton *)btn {
    //持仓、委托
    if (btn.selected) {
        return;
    }
    
    NSInteger index = btn.tag - 4000;
    [self.arrayCurrentBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = YES;
            obj.titleLabel.font = kBoldFont(14);
        } else {
            obj.selected = NO;
            obj.titleLabel.font = kFont(12);
        }
    }];
    if (index == 0) {
        [self.btnPingCang setTitle:NSLocalizedString(@"一键平仓", nil) forState:UIControlStateNormal];
    } else {
        [self.btnPingCang setTitle:NSLocalizedString(@"全部撤销", nil) forState:UIControlStateNormal];
    }
    
    if (self.onBtnWithSelectCurrentBlock) {
        self.onBtnWithSelectCurrentBlock(index);
    }
}

- (void)onBtnWithCheckPingCangRecordsEvent:(UIButton *)btn {
    //平仓记录
    if (self.onBtnWithCheckCloseRecordsBlock) {
        self.onBtnWithCheckCloseRecordsBlock();
    }
}

- (void)onBtnWithShowAllEvent:(UIButton *)btn {
    //显示全部
    btn.selected = YES;
    self.btnCurrent.selected = NO;
    if (self.onBtnWithSelectAllOrCurrentBlock) {
        self.onBtnWithSelectAllOrCurrentBlock(0);
    }
}

- (void)onBtnWithShowCurrentEvent:(UIButton *)btn {
    //显示当前合约
    btn.selected = YES;
    self.btnAll.selected = NO;
    if (self.onBtnWithSelectAllOrCurrentBlock) {
        self.onBtnWithSelectAllOrCurrentBlock(1);
    }
}

- (void)onBtnWithPingCangEvent:(UIButton *)btn {
    //一键平仓、全部撤销
    if (self.onBtnCloseingOrCancelContractBlock) {
        self.onBtnCloseingOrCancelContractBlock();
    }
}

- (void)onTextFieldChangeValue:(UITextField *)textField {
    [self calculationLotValue];
}

- (void)onLotTextFieldChangeValue:(UITextField *)tf {
    [self calculation];
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.arrayPriceBtns) {
        [self.arrayPriceBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayPriceBtns removeAllObjects];
    }
    [self.arrayPriceBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(68, 188, 167) highlightedTitleColor:kRGB(68, 188, 167) font:kFont(14) target:self selector:@selector(onBtnWithSelectPriceEvent:)];
        [btn setTitleColor:kRGB(255, 255, 255) forState:UIControlStateSelected];
        btn.layer.cornerRadius = 2;
        btn.layer.borderColor = kRGB(68, 188, 167).CGColor;
        btn.layer.borderWidth = 1;
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = idx + 1000;
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15 + 95 * idx + 10 * idx);
            make.top.equalTo(20);
            make.width.equalTo(95);
            make.height.equalTo(32);
        }];
        [self.arrayPriceBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
            btn.backgroundColor = kRGB(68, 188, 167);
        }
    }];
    
    self.lbFull = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:self.lbFull];
    [self.lbFull makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(67);
        make.left.equalTo(15);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbFull.mas_bottom).offset(10);
        make.left.equalTo(0);
        make.height.equalTo(20);
        make.width.equalTo(220);
    }];
    
    self.tfPrice = [[UITextField alloc] initWithPlaceHolder:NSLocalizedString(@"输入委托限价", nil) hasLine:NO];
    self.tfPrice.keyboardType = UIKeyboardTypeDecimalPad;
    self.tfPrice.layer.cornerRadius = 2;
    self.tfPrice.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.tfPrice.layer.borderWidth = 1;
    self.tfPrice.hidden = YES;
    [self.tfPrice addTarget:self action:@selector(onTextFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.tfPrice];
    [self.tfPrice makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-(kScreenWidth - 215));
        make.top.equalTo(self.collectionView.mas_bottom).offset(15);
        make.width.equalTo(125);
        make.height.equalTo(32);
    }];
    
    self.lbPriceTitle = [UILabel labelWithText:NSLocalizedString(@"委托价格：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    self.lbPriceTitle.hidden = YES;
    [self addSubview:self.lbPriceTitle];
    [self.lbPriceTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(self.tfPrice);
    }];
    
    self.lbLotValue = [UILabel labelWithText:NSLocalizedString(@"", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:self.lbLotValue];
    [self.lbLotValue makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-(kScreenWidth - 215));
        make.top.equalTo(self.lbFull.mas_bottom).offset(45);
    }];
    
    UILabel *lbLotTitle = [UILabel labelWithText:NSLocalizedString(@"手数：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbLotTitle];
    [lbLotTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(self.lbLotValue);
    }];
    
    UIView *lotView = [[UIView alloc] init];
    lotView.backgroundColor = [UIColor clearColor];
    lotView.layer.cornerRadius = 2;
    lotView.layer.borderColor = kRGB(236, 236, 236).CGColor;
    lotView.layer.borderWidth = 1;
    [self addSubview:lotView];
    [lotView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbLotTitle.mas_bottom).offset(10);
        make.left.equalTo(15);
        make.right.equalTo(self.lbLotValue);
        make.height.equalTo(32);
    }];
    
    UIButton *btnLess = [UIButton buttonWithTitle:@"-" titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(14) target:self selector:@selector(onBtnLessEvent:)];
    [lotView addSubview:btnLess];
    [btnLess makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
        make.width.equalTo(38);
    }];
    
    UIView *lessLineView = [[UIView alloc] init];
    lessLineView.backgroundColor = kRGB(236, 236, 236);
    [lotView addSubview:lessLineView];
    [lessLineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(btnLess.mas_right);
        make.width.equalTo(1);
    }];
    
    self.tfLot = [[UITextField alloc] initWithPlaceHolder:@"" hasLine:NO];
    self.tfLot.keyboardType = UIKeyboardTypeNumberPad;
    self.tfLot.text = @"1";
    self.tfLot.textAlignment = NSTextAlignmentCenter;
    [self.tfLot addTarget:self action:@selector(onLotTextFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [lotView addSubview:self.tfLot];
    [self.tfLot makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(39);
        make.right.equalTo(-39);
    }];
    
    UIButton *btnAdd = [UIButton buttonWithTitle:@"+" titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(14) target:self selector:@selector(onBtnAddEvent:)];
    [lotView addSubview:btnAdd];
    [btnAdd makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(0);
        make.width.equalTo(38);
    }];
    
    UIView *addLineView = [[UIView alloc] init];
    addLineView.backgroundColor = kRGB(236, 236, 236);
    [lotView addSubview:addLineView];
    [addLineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(btnAdd.mas_left);
        make.width.equalTo(1);
    }];
    
    if (self.arrayPercentBtns) {
        [self.arrayPercentBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayPercentBtns removeAllObjects];
    }
    [self.arrayPercentBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:obj titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithSelectPercentEvent:)];
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = kRGB(236, 236, 236).CGColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tag = 3000 + idx;
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lotView.mas_bottom).offset(10);
            make.left.equalTo(15 + 45 * idx + 6.5 * idx);
            make.width.equalTo(45);
            make.height.equalTo(24);
        }];
        [self.arrayPercentBtns addObject:btn];
    }];
    
    UILabel *lbUSDTitle = [UILabel labelWithText:NSLocalizedString(@"委托占用：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbUSDTitle];
    [lbUSDTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lotView.mas_bottom).offset(49);
        make.left.equalTo(15);
    }];
    
    self.lbUSDT = [UILabel labelWithText:@"0.00000000 USDT" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:self.lbUSDT];
    [self.lbUSDT makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lbUSDTitle);
        make.right.equalTo(lotView);
    }];
    
    UILabel *lbMarginTitle = [UILabel labelWithText:NSLocalizedString(@"合约保证金", nil) textColor:kRGB(153, 153, 153) font:kFont(10)];
    [self addSubview:lbMarginTitle];
    [lbMarginTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(lbUSDTitle.mas_bottom).offset(10);
    }];
    
    self.lbMargin = [UILabel labelWithText:@"0.00000000" textColor:kRGB(153, 153, 153) font:kFont(10)];
    [self addSubview:self.lbMargin];
    [self.lbMargin makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lbUSDT);
        make.centerY.equalTo(lbMarginTitle);
    }];
    
    UILabel *lbFeeTitle = [UILabel labelWithText:NSLocalizedString(@"开仓手续费", nil) textColor:kRGB(153, 153, 153) font:kFont(10)];
    [self addSubview:lbFeeTitle];
    [lbFeeTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbMarginTitle.mas_bottom).offset(10);
        make.left.equalTo(lbMarginTitle);
    }];
    
    self.lbFee = [UILabel labelWithText:@"0.00000000" textColor:kRGB(153, 153, 153) font:kFont(10)];
    [self addSubview:self.lbFee];
    [self.lbFee makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lbUSDT);
        make.centerY.equalTo(lbFeeTitle);
    }];
    
    UIButton *btnBuy = [UIButton buttonWithTitle:NSLocalizedString(@"买入/做多", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnBuyEvent:)];
    btnBuy.backgroundColor = kRGB(68, 188, 167);
    btnBuy.layer.cornerRadius = 2;
    btnBuy.custom_acceptEventInterval = 1.5;
    [self addSubview:btnBuy];
    [btnBuy makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbFeeTitle.mas_bottom).offset(10);
        make.left.equalTo(15);
        make.width.equalTo(95);
        make.height.equalTo(32);
    }];
    
    UIButton *btnSell = [UIButton buttonWithTitle:NSLocalizedString(@"卖出/做空", nil) titleColor:kRedColor highlightedTitleColor:kRedColor font:kFont(14) target:self selector:@selector(onBtnSellEvent:)];
    btnSell.backgroundColor = [UIColor clearColor];
    btnSell.layer.cornerRadius = 2;
    btnSell.layer.borderColor = kRedColor.CGColor;
    btnSell.layer.borderWidth = 1;
    btnSell.custom_acceptEventInterval = 1.5;
    [self addSubview:btnSell];
    [btnSell makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lotView);
        make.width.equalTo(95);
        make.height.equalTo(32);
        make.centerY.equalTo(btnBuy);
    }];
    
    self.lbAvailable = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:self.lbAvailable];
    [self.lbAvailable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBuy.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    UILabel *lbPriceTitle = [UILabel labelWithText:NSLocalizedString(@"价格(USDT)", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
    [self addSubview:lbPriceTitle];
    [lbPriceTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(28);
        make.left.equalTo(230);
    }];
    
    UILabel *lbNumberTitle = [UILabel labelWithText:NSLocalizedString(@"数量", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
    [self addSubview:lbNumberTitle];
    [lbNumberTitle makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(lbPriceTitle);
    }];
    
    [self addSubview:self.sellTableView];
    [self.sellTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbPriceTitle.mas_bottom).offset(10);
        make.left.equalTo(lbPriceTitle);
        make.right.equalTo(-15);
        make.height.equalTo(130);
    }];
    
    self.lbNewPrice = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kBoldFont(15)];
    [self addSubview:self.lbNewPrice];
    [self.lbNewPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sellTableView);
        make.top.equalTo(self.sellTableView.mas_bottom).offset(5);
    }];
    
    self.lbRate = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:self.lbRate];
    [self.lbRate makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(self.lbNewPrice);
    }];
    
    [self addSubview:self.buyTableView];
    [self.buyTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sellTableView.mas_bottom).offset(31);
        make.left.right.height.equalTo(self.sellTableView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbAvailable.mas_bottom).offset(20);
        make.left.right.equalTo(0);
        make.height.equalTo(0.5);
    }];
    
    if (self.arrayCurrentBtns) {
        [self.arrayCurrentBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayCurrentBtns removeAllObjects];
    }
    [self.arrayCurrentBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(153, 153, 153) highlightedTitleColor:kRGB(153, 153, 153) font:kFont(12) target:self selector:@selector(onBtnWithSelectCurrentEvent:)];
        [btn setTitleColor:kRGB(16, 16, 16) forState:UIControlStateSelected];
        btn.tag = 4000 + idx;
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).offset(10);
            make.left.equalTo(15 + 58 * idx);
            make.width.equalTo(58);
            make.height.equalTo(20);
        }];
        [self.arrayCurrentBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
            btn.titleLabel.font = kBoldFont(14);
        }
    }];
    
    UIButton *btnPingCangRecords = [UIButton buttonWithTitle:NSLocalizedString(@"平仓记录", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(8) target:self selector:@selector(onBtnWithCheckPingCangRecordsEvent:)];
    [btnPingCangRecords setImage:[StatusHelper imageNamed:@"lite_kline_order"] forState:UIControlStateNormal];
    [self addSubview:btnPingCangRecords];
    [btnPingCangRecords makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(55);
        make.height.equalTo(30);
        make.top.equalTo(lineView.mas_bottom).offset(5);
        make.right.equalTo(-15);
    }];
    [btnPingCangRecords setTitleRightSpace:5];
    
    CGFloat btnAllW = [NSLocalizedString(@"显示全部", nil) widthForFont:kFont(12) maxHeight:30] + 30;
    self.btnAll = [UIButton buttonWithTitle:NSLocalizedString(@"显示全部", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithShowAllEvent:)];
    [self.btnAll setImage:[UIImage imageNamed:@"zctk-wxz-1"] forState:UIControlStateSelected];
    [self.btnAll setImage:[UIImage imageNamed:@"zctk-wxz-2"] forState:UIControlStateNormal];
    self.btnAll.selected = YES;
    [self addSubview:self.btnAll];
    [self.btnAll makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(btnAllW);
        make.height.equalTo(30);
        make.bottom.equalTo(-10);
    }];
    [self.btnAll setTitleRightSpace:5];
    
    CGFloat btnCurrentW = [NSLocalizedString(@"显示当前合约", nil) widthForFont:kFont(12) maxHeight:30] + 30;
    self.btnCurrent = [UIButton buttonWithTitle:NSLocalizedString(@"显示当前合约", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithShowCurrentEvent:)];
    [self.btnCurrent setImage:[UIImage imageNamed:@"zctk-wxz-1"] forState:UIControlStateSelected];
    [self.btnCurrent setImage:[UIImage imageNamed:@"zctk-wxz-2"] forState:UIControlStateNormal];
    [self addSubview:self.btnCurrent];
    [self.btnCurrent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnAll.mas_right).offset(40);
        make.width.equalTo(btnCurrentW);
        make.height.equalTo(30);
        make.centerY.equalTo(self.btnAll);
    }];
    [self.btnCurrent setTitleRightSpace:5];
    
    self.btnPingCang = [UIButton buttonWithTitle:NSLocalizedString(@"一键平仓", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithPingCangEvent:)];
    self.btnPingCang.custom_acceptEventInterval = 3;
    [self addSubview:self.btnPingCang];
    [self.btnPingCang makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.width.equalTo(50);
        make.height.equalTo(20);
        make.centerY.equalTo(self.btnCurrent);
    }];
    
    self.selectIndex = 0;
    self.symbols = @"BTC/USDT";
}

- (void)timeAction {
    NSDictionary *params1 = @{@"symbol" : self.symbols,
                              @"type" : @"1"
    };
    [Service fetchCurrencyDealInfoWithParams:params1 mapper:[TradeListModel class] showHUD:NO success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            [self setViewQuotesDealInfoWithModel:responseModel.data];
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取币种交易信息失败");
    }];
}

- (void)updateView {
    self.selectLeverageIndex = 0;
    self.symbols = @"BTC/USDT";
    self.percentValue = 0.00;
   
    WeakSelf
    [self.arrayPercentBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        obj.backgroundColor = [UIColor clearColor];
        weakSelf.percentValue = 0.00;
    }];
//    self.lbLot.text = @"1";
    self.tfLot.text = @"1";
    
    self.tfPrice.text = @"";
}

//合约页面信息
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[SymbolModel class]]) {
        SymbolModel *symbolModel = model;
        self.symbols = symbolModel.symbols;
        self.coin = [self.symbols substringToIndex:self.symbols.length - 5];
        //全仓杠杆倍率记录
        self.arrayCollectionDatas = symbolModel.leverageList;
        //一手价值
        self.lbLotValue.text = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"一手价值", nil), symbolModel.handNumber, self.coin];
        self.lotValue = [symbolModel.handNumber integerValue];
        //可用余额
        self.lbAvailable.text = [NSString stringWithFormat:@"%@ %.8fUSDT", NSLocalizedString(@"可用余额", nil), [symbolModel.price floatValue]];
        self.lbAvailable.attributedText = [self.lbAvailable.text attributedStringWithSubString:[NSString stringWithFormat:@"%.8fUSDT", [symbolModel.price floatValue]] subColor:kRGB(205, 61, 88)];
        self.availableBalance = [symbolModel.price floatValue];
        //开仓手续费率
        self.feeRatio = [symbolModel.openFeePrice doubleValue] / 100;
        if (symbolModel.leverageList) {
            self.arrayCollectionDatas = symbolModel.leverageList;
            LeverageListModel *leverageModel = self.arrayCollectionDatas[0];
            self.lbFull.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"全仓倍数", nil), leverageModel.name];
            
            NSString *leverageValue = [leverageModel.name substringToIndex:leverageModel.name.length - 1];
            self.leverageValue = [leverageValue floatValue];
            
            [self.collectionView reloadData];
        }
        
        self.tfPrice.text = @"";
        
        [self calculation];
        [self timeAction];
    }
}

//当前币种行情
- (void)setViewQuotesWithModel:(id)model {
    if (model && [model isKindOfClass:[QuotesModel class]]) {
        QuotesModel *quotesModel = model;        
        //需要保留的小数点位数
        NSInteger number = [quotesModel.number integerValue];
        NSString *format = [NSString stringWithFormat:@"%%.%ldf", (long)number];
        self.lbNewPrice.text = [NSString stringWithFormat:format, [quotesModel.close floatValue]];
        //涨跌幅
        self.lbRate.text = [NSString stringWithFormat:@"%.2f%%", [quotesModel.rose floatValue]];
        self.lbRate.textColor = [quotesModel.rose containsString:@"-"] ? kRedColor : kGreenColor;
    }
}

//币种交易信息
- (void)setViewQuotesDealInfoWithModel:(id)model {
    if (model && [model isKindOfClass:[TradeListModel class]]) {
        TradeListModel *tradeListModel = model;
        NSMutableArray *arrayBids = [NSMutableArray arrayWithCapacity:5];
        
        NSMutableArray *asksArr = [[NSMutableArray alloc] initWithArray:tradeListModel.asks];

        __block CGFloat bidsArrayMax = 0;     //取买单最大的值
        if (tradeListModel.bids && [tradeListModel.bids count]) {
        //所有买单(从高到低)
            if ([tradeListModel.bids count] >= 5) {
                for (int i = 0; i < 5; i ++) {
                    NSArray *array = tradeListModel.bids[i];
                    if (bidsArrayMax < [array[1] floatValue]) {
                        bidsArrayMax = [array[1] floatValue];
                    }
                    [arrayBids addObject:array];
                }
            } else {
                [tradeListModel.bids enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (bidsArrayMax < [obj[1] floatValue]) {
                        bidsArrayMax = [obj[1] floatValue];
                    }
                    [arrayBids addObject:obj];
                }];
            }
        }
        NSMutableArray *arrayAsks = [NSMutableArray arrayWithCapacity:5];
        __block CGFloat asksArrayMax = 0;      //取卖单最大的值
        if (tradeListModel.asks && [tradeListModel.asks count]) {
            //所有卖单（从高到低）
            if ([tradeListModel.asks count] >= 5) {
                for (int i = 4; i < tradeListModel.asks.count; i --) {
                    NSArray *array = tradeListModel.asks[i];
                    if (asksArrayMax < [array[1] floatValue]) {
                        //取出最大的价格数量
                        asksArrayMax = [array[1] floatValue];
                    }
                    [arrayAsks addObject:array];
                }
            } else {
                [tradeListModel.asks enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (asksArrayMax < [obj[1] floatValue]) {
                        asksArrayMax = [obj[1] floatValue];
                    }
                    [arrayAsks addObject:obj];
                }];
            }
        }
        //取买单和卖单最大的值；
        self.buyTableView.maxNumber = bidsArrayMax;
        self.buyTableView.arrayTableDatas = arrayBids;
        self.buyTableView.type = @"buy";
        self.buyTableView.number = tradeListModel.number;

        self.sellTableView.maxNumber = asksArrayMax;
        self.sellTableView.arrayTableDatas = arrayAsks;
        self.sellTableView.type = @"sell";
        self.sellTableView.number = tradeListModel.number;
    }
}

#pragma mark - Setter & Getter
- (NSMutableArray<UIButton *> *)arrayPriceBtns {
    if (!_arrayPriceBtns) {
        _arrayPriceBtns = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayPriceBtns;
}

- (NSArray<NSString *> *)arrayPriceBtnTitles {
    if (!_arrayPriceBtnTitles) {
        _arrayPriceBtnTitles = @[@"市价", @"限价"];
    }
    return _arrayPriceBtnTitles;
}

- (NSMutableArray<UIButton *> *)arrayPercentBtns {
    if (!_arrayPercentBtns) {
        _arrayPercentBtns = [NSMutableArray arrayWithCapacity:4];
    }
    return _arrayPercentBtns;
}

- (NSArray<NSString *> *)arrayPercentBtnTitles {
    if (!_arrayPercentBtnTitles) {
        _arrayPercentBtnTitles = @[@"25%", @"50%", @"75%", @"100%"];
    }
    return _arrayPercentBtnTitles;
}

- (NSMutableArray<UIButton *> *)arrayCurrentBtns {
    if (!_arrayCurrentBtns) {
        _arrayCurrentBtns = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayCurrentBtns;
}

- (NSArray<NSString *> *)arrayCurrentBtnTitles {
    if (!_arrayCurrentBtnTitles) {
        _arrayCurrentBtnTitles = @[@"当前持仓", @"当前委托"];
    }
    return _arrayCurrentBtnTitles;
}

- (ContractTableView *)sellTableView {
    if (!_sellTableView) {
        _sellTableView = [[ContractTableView alloc] init];
    }
    return _sellTableView;
}

- (ContractTableView *)buyTableView {
    if (!_buyTableView) {
        _buyTableView = [[ContractTableView alloc] init];
    }
    return _buyTableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LeverageCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([LeverageCollectionCell class])];
    }
    return _collectionView;
}

@end
