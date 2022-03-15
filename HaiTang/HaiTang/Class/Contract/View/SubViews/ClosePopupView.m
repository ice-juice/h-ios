//
//  ClosePopupView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ClosePopupView.h"

#import "RecordSubModel.h"

@interface ClosePopupView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *tfLot;
@property (nonatomic, strong) UILabel *lbStatus;
@property (nonatomic, strong) UILabel *lbSymbol;
//建仓价格
@property (nonatomic, strong) UILabel *lbOpeningPrice;
//预计盈亏
@property (nonatomic, strong) UILabel *lbProfitAndLoss;
//平仓价值
@property (nonatomic, strong) UILabel *lbCloseValue;
//可平手数
@property (nonatomic, strong) UILabel *lbUsedLot;
//手续费
@property (nonatomic, strong) UILabel *lbFee;

@property (nonatomic, copy) NSString *compactId;
//每手价值数量
@property (nonatomic, assign) CGFloat oneLotNumber;
//币种
@property (nonatomic, copy) NSString *symbol;
//手续费率
@property (nonatomic, assign) CGFloat closeFeeRatio;
//可平手数
@property (nonatomic, assign) NSInteger number;

@end

@implementation ClosePopupView
#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1;
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12;
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.left.equalTo(30);
        make.height.equalTo(440);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"平仓", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(18)];
    [self.contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(40);
        make.centerX.equalTo(0);
    }];
    
    self.lbStatus = [UILabel labelWithText:@"" textColor:kRGB(0, 102, 237) font:kBoldFont(18)];
    [self.contentView addSubview:self.lbStatus];
    [self.lbStatus makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(80);
    }];
    
    self.lbSymbol = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(18)];
    [self.contentView addSubview:self.lbSymbol];
    [self.lbSymbol makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbStatus.mas_bottom).offset(5);
        make.left.equalTo(20);
    }];
    
    UILabel *lbOpengingPriceT = [UILabel labelWithText:NSLocalizedString(@"建仓价格", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:lbOpengingPriceT];
    [lbOpengingPriceT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbSymbol.mas_bottom).offset(20);
        make.left.equalTo(20);
    }];
    
    self.lbOpeningPrice = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:self.lbOpeningPrice];
    [self.lbOpeningPrice makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(lbOpengingPriceT);
    }];
    
    UILabel *lbClosePriceT = [UILabel labelWithText:NSLocalizedString(@"平仓价格", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:lbClosePriceT];
    [lbClosePriceT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbOpengingPriceT.mas_bottom).offset(15);
        make.left.equalTo(20);
    }];
    
    self.lbClosePrice = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:self.lbClosePrice];
    [self.lbClosePrice makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(lbClosePriceT);
    }];
    
    UILabel *lbProfitAndLossT = [UILabel labelWithText:NSLocalizedString(@"预计盈亏", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:lbProfitAndLossT];
    [lbProfitAndLossT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbClosePriceT.mas_bottom).offset(15);
        make.left.equalTo(20);
    }];
    
    self.lbProfitAndLoss = [UILabel labelWithText:@"" textColor:kRGB(68, 188, 167) font:kFont(12)];
    [self.contentView addSubview:self.lbProfitAndLoss];
    [self.lbProfitAndLoss makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(lbProfitAndLossT);
    }];
    
    UILabel *lbCloseLotT = [UILabel labelWithText:NSLocalizedString(@"平仓手数", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:lbCloseLotT];
    [lbCloseLotT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbProfitAndLossT.mas_bottom).offset(15);
        make.left.equalTo(20);
    }];
    
    self.lbCloseValue = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:self.lbCloseValue];
    [self.lbCloseValue makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(lbCloseLotT);
    }];
    
    self.tfLot = [[UITextField alloc] initWithPlaceHolder:NSLocalizedString(@"输入平仓手数", nil) hasLine:NO];
    self.tfLot.keyboardType = UIKeyboardTypeNumberPad;
    self.tfLot.layer.cornerRadius = 2;
    self.tfLot.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.tfLot.layer.borderWidth = 1;
    [self.tfLot addTarget:self action:@selector(onTextFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.tfLot];
    [self.tfLot makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbCloseLotT.mas_bottom).offset(10);
        make.left.equalTo(20);
        make.right.equalTo(-20);
        make.height.equalTo(32);
    }];
    
    self.lbUsedLot = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:self.lbUsedLot];
    [self.lbUsedLot makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfLot.mas_bottom).offset(15);
        make.left.equalTo(20);
    }];
    
    self.lbFee = [UILabel labelWithText:[NSString stringWithFormat:@"%@：0.00", NSLocalizedString(@"平仓手续费", nil)] textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:self.lbFee];
    [self.lbFee makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(self.lbUsedLot);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithTitle:NSLocalizedString(@"再想想", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnCancelEvent:)];
    btnCancel.layer.cornerRadius = 2;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = kRGB(0, 102, 237).CGColor;
    [self.contentView addSubview:btnCancel];
    [btnCancel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-27);
        make.left.equalTo(20);
        make.width.equalTo(125);
        make.height.equalTo(34);
    }];
    
    UIButton *btnCloseing = [UIButton buttonWithTitle:NSLocalizedString(@"平仓", nil) titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(255, 255, 255) font:kFont(14) target:self selector:@selector(onBtnCloseingEvent:)];
    btnCloseing.layer.cornerRadius = 2;
    btnCloseing.backgroundColor = kRGB(0, 102, 237);
    [self.contentView addSubview:btnCloseing];
    [btnCloseing makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-27);
        make.right.equalTo(-20);
        make.width.equalTo(125);
        make.height.equalTo(34);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[RecordSubModel class]]) {
        RecordSubModel *subModel = model;
        self.compactId = subModel.compactId;
        self.lbStatus.text = [subModel.compactType isEqualToString:@"BUY"] ? NSLocalizedString(@"多仓", nil) : NSLocalizedString(@"空仓", nil);
        self.lbSymbol.text = [NSString stringWithFormat:@"%@ %@", subModel.leverName, subModel.symbols];
        self.lbOpeningPrice.text = [NSString stringWithFormat:@"%.1f", [subModel.tradePrice floatValue]];
        
        UIColor *textColor = [subModel.lossProfit containsString:@"-"] ? kRedColor : kGreenColor;
        self.lbProfitAndLoss.text = [NSString stringWithFormat:@"%.2f", [subModel.lossProfit floatValue]];
        self.lbProfitAndLoss.textColor = textColor;
        
        self.symbol = [subModel.symbols substringToIndex:subModel.symbols.length - 5];
        
        self.lbUsedLot.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"可平手数", nil), subModel.numbers];
        self.tfLot.text = subModel.numbers;
        self.number = [subModel.numbers integerValue];
        
        self.oneLotNumber = [subModel.handNumber floatValue];
        
        self.closeFeeRatio = [subModel.exitFeeRatio floatValue] / 100.0;
        
        [self calculationCloseValue];
        
        [self showView];
    }
}

#pragma mark - Private Method
- (void)showView {    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth - 60, 440)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, (kScreenHeight - 440) / 2, kScreenWidth - 60, 440)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}

- (void)calculationCloseValue {
    //平仓价值数量 = 平仓手数 * 每手价值数量
    CGFloat number = [self.tfLot.text floatValue] * self.oneLotNumber;
    if (isnan(number)) {
        number = 0.00;
    }
    if (isinf(number)) {
        number = 0.00;
    }
    self.lbCloseValue.text = [NSString stringWithFormat:@"%@ %.2f%@", NSLocalizedString(@"平仓价值", nil), number, self.symbol];
    
    CGFloat profitAndLoss = 0.00;
    if ([self.lbStatus.text containsString:NSLocalizedString(@"多仓", nil)]) {
        //多仓预计盈亏 = 平仓价值数量 * （平仓价格 - 建仓价格）
        profitAndLoss = number * ([self.lbClosePrice.text floatValue] - [self.lbOpeningPrice.text floatValue]);
    } else {
        //空仓预计盈亏 = 平仓价值数量 * （建仓价格 - 平仓价格）
        profitAndLoss = number * ([self.lbOpeningPrice.text floatValue] - [self.lbClosePrice.text floatValue]);
    }
    if (isnan(profitAndLoss)) {
        profitAndLoss = 0.00;
    }
    if (isinf(profitAndLoss)) {
        profitAndLoss = 0.00;
    }
    self.lbProfitAndLoss.text = [NSString stringWithFormat:@"%.2f", profitAndLoss];
    
    //手续费 = 平仓价值数量 * 平仓价格 * 平仓手续费率
    CGFloat fee = number * [self.lbClosePrice.text floatValue] * self.closeFeeRatio;
    if (isnan(fee)) {
        fee = 0.00;
    }
    if (isinf(fee)) {
        fee = 0.00;
    }
    self.lbFee.text = [NSString stringWithFormat:@"%@%.2f", NSLocalizedString(@"平仓手续费", nil), fee];
}

- (void)calculationProfitAndLoss {
    //计算预计盈亏
    CGFloat number = [self.tfLot.text floatValue] * self.oneLotNumber;
    if (isnan(number)) {
        number = 0.00;
    }
    if (isinf(number)) {
        number = 0.00;
    }
    CGFloat profitAndLoss = 0.00;
    if ([self.lbStatus.text containsString:NSLocalizedString(@"多仓", nil)]) {
        //多仓预计盈亏 = 平仓价值数量 * （平仓价格 - 建仓价格）
        profitAndLoss = number * ([self.lbClosePrice.text floatValue] - [self.lbOpeningPrice.text floatValue]);
    } else {
        //空仓预计盈亏 = 平仓价值数量 * （建仓价格 - 平仓价格）
        profitAndLoss = number * ([self.lbOpeningPrice.text floatValue] - [self.lbClosePrice.text floatValue]);
    }
    if (isnan(profitAndLoss)) {
        profitAndLoss = 0.00;
    }
    if (isinf(profitAndLoss)) {
        profitAndLoss = 0.00;
    }
    self.lbProfitAndLoss.text = [NSString stringWithFormat:@"%.2f", profitAndLoss];
}

#pragma mark - Event Response
- (void)onBtnCancelEvent:(UIButton *)btn {
    [self closeView];
}

- (void)onBtnCloseingEvent:(UIButton *)btn {
    //平仓
    if ([NSString isEmpty:self.tfLot.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入平仓手数", nil) duration:2];
    }
    if ([self.tfLot.text integerValue] < 0) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入平仓手数", nil) duration:2];
    }
    if ([self.tfLot.text integerValue] > self.number) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"不得大于可平手数", nil) duration:2];
    }
    if (self.onBtnCloseingBlock) {
        self.onBtnCloseingBlock(self.compactId, self.tfLot.text);
    }
    [self closeView];
}

- (void)onTextFieldChangeValue:(UITextField *)textField {
    [self calculationCloseValue];
}

@end


