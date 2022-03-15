//
//  CoinTableHeaderView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CoinTableHeaderView.h"
#import "ContractTableView.h"
#import "DropDownView.h"

#import "Service.h"
#import "SymbolModel.h"
#import "QuotesModel.h"
#import "TradeListModel.h"

@interface CoinTableHeaderView ()<UITextFieldDelegate>
{
    BOOL isHaveDian;
}
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayMethodBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayMethodeBtnTitles;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayPercentBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayPercentBtnTitles;

@property (nonatomic, strong) UITextField *tfCommission;
@property (nonatomic, strong) UITextField *tfPrice;
@property (nonatomic, strong) UITextField *tfNumber;
@property (nonatomic, strong) UILabel *lbSymbol;
@property (nonatomic, strong) UILabel *lbFee;      //手续费
@property (nonatomic, strong) UILabel *lbAvailable;//可用余额
@property (nonatomic, strong) UILabel *lbNewPrice; //最新行情价
@property (nonatomic, strong) UILabel *lbRate;     //涨跌幅
@property (nonatomic, strong) UIButton *btnMethod;
@property (nonatomic, strong) ContractTableView *sellTableView;
@property (nonatomic, strong) ContractTableView *buyTableView;
@property (nonatomic, strong) DropDownView *dropDownView;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, copy) NSString *symbol;      //币种名
@property (nonatomic, assign) CGFloat feeRatio;    //手续费率
@property (nonatomic, assign) CGFloat available;   //可用余额
@property (nonatomic, assign) CGFloat percent;     //百分比（默认0）
@property (nonatomic, assign) CGFloat minBuyNumber;//最小委托量
@property (nonatomic, copy) NSString *matchType;   //类型 BUY-买入 SELL-卖出
@property (nonatomic, copy) NSString *dealWay;     //交易方式 MARKET-市价 LIMIT-限价（默认市价）
@property (nonatomic, strong) UIColor *matchBackgroundColor;   //买入、卖出背景色

@property (nonatomic, strong) NSTimer *timer;
//限制输入的小数点位数
@property (nonatomic, assign) NSInteger pointNumber;

@end

@implementation CoinTableHeaderView
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        //数据格式正确
        if ((single >= '0' && single <= '9') || single == '.') {
            //首字母不能为0和小数点
            if([textField.text length] == 0) {
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                //text中还没有小数点
                if(!isHaveDian) {
                    isHaveDian = YES;
                    return YES;
                } else {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                //存在小数点
                if (isHaveDian) {
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= self.pointNumber) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        } else {
            //输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
}

#pragma mark - Event Response
- (void)onBtnWithSelectMethodEvent:(UIButton *)btn {
    //买入、卖出
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    [self.arrayMethodBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = YES;
            [obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (idx == 1) {
                obj.backgroundColor = kRGB(205, 61, 88);
                obj.layer.borderColor = kRGB(205, 61, 88).CGColor;
                self.btnMethod.backgroundColor = kRGB(205, 61, 88);
                [self.btnMethod setTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"卖出", nil), self.symbol] forState:UIControlStateNormal];
                self.matchBackgroundColor = kRGB(205, 61, 88);
                if (self.percent > 0) {
                    self.selectBtn.backgroundColor = kRGB(205, 61, 88);
                }
            } else {
                obj.backgroundColor = kRGB(68, 188, 167);
                obj.layer.borderColor = kRGB(68, 188, 167).CGColor;
                self.btnMethod.backgroundColor = kRGB(68, 188, 167);
                [self.btnMethod setTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"买入", nil), self.symbol] forState:UIControlStateNormal];
                self.matchBackgroundColor = kRGB(68, 188, 167);
                if (self.percent > 0) {
                    self.selectBtn.backgroundColor = kRGB(68, 188, 167);
                }
            }
        } else {
            obj.selected = NO;
            obj.backgroundColor = [UIColor clearColor];
            if (idx == 1) {
                obj.layer.borderColor = kRGB(68, 188, 167).CGColor;
                [obj setTitleColor:kRGB(68, 188, 167) forState:UIControlStateNormal];
            } else {
                obj.layer.borderColor = kRGB(205, 61, 88).CGColor;
                [obj setTitleColor:kRGB(205, 61, 88) forState:UIControlStateNormal];
            }
        }
    }];
    
    self.matchType = index == 0 ? @"BUY" : @"SELL";
    
    [self calculateNumber];
    
    if (self.onDidSelectMatchTypeBlock) {
        self.onDidSelectMatchTypeBlock(self.matchType);
    }
}

- (void)onBtnWithSelectCommissionEvent:(UIButton *)btn {
    //选择委托
    [self.dropDownView showViewWithX:15 y:kNavBarHeight + 97 width:200 height:70];
}

- (void)onBtnWithSelectPercentEvent:(UIButton *)btn {
    //百分比
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 3000;
    [self.arrayPercentBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            self.selectBtn = obj;
            self.selectBtn.backgroundColor = self.matchBackgroundColor;
            [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            obj.selected = NO;
            obj.backgroundColor = [UIColor clearColor];
            [obj setTitleColor:kRGB(16, 16, 16) forState:UIControlStateNormal];
        }
    }];
    
    NSArray *arrayPercent = @[@"0.25", @"0.50", @"0.75", @"1.00"];
    self.percent = [arrayPercent[index] floatValue];
    
    [self calculateNumber];
}

- (void)onBtnWithCheckDealRecordsEvent:(UIButton *)btn {
    //成交记录
    if (self.onBtnWithCheckDealRecordBlock) {
        self.onBtnWithCheckDealRecordBlock();
    }
}

- (void)onBtnWithSubmitEvent:(UIButton *)btn {
    NSString *price = self.lbNewPrice.text;
    if ([self.dealWay isEqualToString:@"LIMIT"]) {
        //限价
        if ([NSString isEmpty:self.tfPrice.text] || [self.tfPrice.text floatValue] <= 0) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入委托价格", nil) duration:2];
        }
        price = self.tfPrice.text;
    }
    if ([NSString isEmpty:self.tfNumber.text] || [self.tfNumber.text floatValue] <= 0) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入委托数量", nil) duration:2];
    }
    if ([self.tfNumber.text floatValue] < self.minBuyNumber) {
        return [JYToastUtils showWithStatus:[NSString stringWithFormat:@"不能小于%.8f", self.minBuyNumber] duration:2];
    }
    if (self.onBtnWithSubmitDealBlock) {
        self.onBtnWithSubmitDealBlock(price, self.tfNumber.text);
    }
}

- (void)onPriceTextFieldChangeValue:(UITextField *)textFiled {
    //输入价格
    [self calculateNumber];
}

- (void)onNumberTextFieldChangeValue:(UITextField *)textField {
    //输入数量
    [self calculateFee];
}

- (void)calculateFee {
    //计算手续费
    CGFloat fee = 0.0000000000;
    //单位
    NSString *unitStr = self.symbol;
    
    //委托价格 市价=当前行情价 限价=自定义价格
    CGFloat commissionPrice = [self.dealWay isEqualToString:@"MARKET"] ? [self.lbNewPrice.text floatValue] : [self.tfPrice.text floatValue];
    CGFloat commissionValue = 0.000000000;
    
    if ([self.matchType isEqualToString:@"BUY"]) {
        //买入 手续费 = 委托数量 * 手续费率
        fee = [self.tfNumber.text floatValue] * (self.feeRatio / 100);
        unitStr = self.symbol;
    } else {
        //委托价值 = 价格 * 数量
        commissionValue = commissionPrice * self.tfNumber.text.floatValue;
        //卖出 手续费 = 委托价值 * 手续费率
        fee = commissionValue * (self.feeRatio / 100);
        unitStr = @"USDT";
    }
    self.lbFee.text = [NSString stringWithFormat:@"%.8f %@", fee, unitStr];
}

- (void)calculateNumber {
    //输入数量
    //委托价格 市价=当前行情价 限价=自定义价格
    CGFloat commissionPrice = [self.dealWay isEqualToString:@"MARKET"] ? [self.lbNewPrice.text floatValue] : [self.tfPrice.text floatValue];
    //输入数量
    CGFloat number = 0.00;
    if ([self.matchType isEqualToString:@"BUY"]) {
        //买入输入数量 = 可用余额 * 比例 / 委托价格
        number = (self.available * self.percent) / commissionPrice;
    } else {
        //卖出输入数量 = 可用余额 * 比例
        number = self.available * self.percent;
    }
    if (isnan(number)) {
        number = 0.00;
    }
    if (isinf(number)) {
        number = 0.00;
    }
    
    self.tfNumber.text = [NSString stringWithFormat:@"%.6f", number];
    
    [self calculateFee];
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    if (self.arrayMethodBtns) {
        [self.arrayMethodBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayMethodBtns removeAllObjects];
    }
    [self.arrayMethodeBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(68, 188, 167) highlightedTitleColor:kRGB(68, 188, 167) font:kFont(14) target:self selector:@selector(onBtnWithSelectMethodEvent:)];
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
        [self.arrayMethodBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
            btn.backgroundColor = kRGB(68, 188, 167);
        }
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    UIImageView *imgViewDown = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"bibi-xl"]];
    imgViewDown.frame = CGRectMake(12, 9, 10, 14);
    [rightView addSubview:imgViewDown];
    
    self.tfCommission = [[UITextField alloc] initWithPlaceHolder:NSLocalizedString(@"市价委托", nil) hasLine:NO];
    self.tfCommission.rightView = rightView;
    self.tfCommission.rightViewMode = UITextFieldViewModeAlways;
    self.tfCommission.layer.cornerRadius = 2;
    self.tfCommission.layer.borderWidth = 1;
    self.tfCommission.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.tfCommission.enabled = NO;
    [self addSubview:self.tfCommission];
    [self.tfCommission makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(200);
        make.top.equalTo(67);
        make.height.equalTo(32);
    }];
    
    UIButton *btnCommission = [UIButton buttonWithTarget:self selector:@selector(onBtnWithSelectCommissionEvent:)];
    [self addSubview:btnCommission];
    [btnCommission makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tfCommission);
    }];
    
    UIView *rightView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 32)];
    UILabel *lbUSDT = [UILabel labelWithText:@"USDT" textColor:kRGB(153, 153, 153) font:kFont(12)];
    lbUSDT.frame = CGRectMake(0, 0, 34, 32);
    lbUSDT.textAlignment = NSTextAlignmentRight;
    [rightView1 addSubview:lbUSDT];
    
    self.tfPrice = [[UITextField alloc] initWithPlaceHolder:NSLocalizedString(@"市价", nil) hasLine:NO];
    self.tfPrice.keyboardType = UIKeyboardTypeDecimalPad;
    self.tfPrice.rightView = rightView1;
    self.tfPrice.rightViewMode = UITextFieldViewModeAlways;
    self.tfPrice.layer.cornerRadius = 2;
    self.tfPrice.layer.borderWidth = 1;
    self.tfPrice.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.tfPrice.enabled = NO;
    self.tfPrice.delegate = self;
    [self.tfPrice addTarget:self action:@selector(onPriceTextFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.tfPrice];
    [self.tfPrice makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(200);
        make.top.equalTo(self.tfCommission.mas_bottom).offset(15);
        make.height.equalTo(32);
    }];
    
    UIView *rightView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 32)];
    self.lbSymbol = [UILabel labelWithText:@"BTC" textColor:kRGB(153, 153, 153) font:kFont(12)];
    self.lbSymbol.frame = CGRectMake(0, 0, 34, 32);
    self.lbSymbol.textAlignment = NSTextAlignmentRight;
    [rightView2 addSubview:self.lbSymbol];
    
    self.tfNumber = [[UITextField alloc] initWithPlaceHolder:NSLocalizedString(@"输入委托数量", nil) hasLine:NO];
    self.tfNumber.keyboardType = UIKeyboardTypeDecimalPad;
    self.tfNumber.rightView = rightView2;
    self.tfNumber.rightViewMode = UITextFieldViewModeAlways;
    self.tfNumber.layer.cornerRadius = 2;
    self.tfNumber.layer.borderWidth = 1;
    self.tfNumber.layer.borderColor = kRGB(236, 236, 236).CGColor;
    [self.tfNumber addTarget:self action:@selector(onNumberTextFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.tfNumber];
    [self.tfNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(200);
        make.top.equalTo(self.tfPrice.mas_bottom).offset(15);
        make.height.equalTo(32);
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
        btn.tag = 3000 + idx;
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tfNumber.mas_bottom).offset(10);
            make.left.equalTo(15 + 45 * idx + 6.5 * idx);
            make.width.equalTo(45);
            make.height.equalTo(24);
        }];
        [self.arrayPercentBtns addObject:btn];
    }];
    
    self.btnMethod = [UIButton buttonWithTitle:NSLocalizedString(@"", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSubmitEvent:)];
    self.btnMethod.backgroundColor = kRGB(68, 188, 167);
    self.btnMethod.layer.cornerRadius = 2;
    self.btnMethod.custom_acceptEventInterval = 1.5;
    [self addSubview:self.btnMethod];
    [self.btnMethod makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfNumber.mas_bottom).offset(53);
        make.left.equalTo(15);
        make.width.equalTo(200);
        make.height.equalTo(32);
    }];
    
    UILabel *lbFeeTitle = [UILabel labelWithText:NSLocalizedString(@"手续费：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbFeeTitle];
    [lbFeeTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnMethod.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
        
    self.lbFee = [UILabel labelWithText:@"" textColor:kRGB(205, 61, 88) font:kFont(12)];
    [self addSubview:self.lbFee];
    [self.lbFee makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tfNumber);
        make.centerY.equalTo(lbFeeTitle);
    }];
    
    UILabel *lbAvailableT = [UILabel labelWithText:NSLocalizedString(@"可用余额：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbAvailableT];
    [lbAvailableT makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbFeeTitle.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
        
    self.lbAvailable = [UILabel labelWithText:@"" textColor:kRGB(205, 61, 88) font:kFont(12)];
    [self addSubview:self.lbAvailable];
    [self.lbAvailable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lbFee);
        make.centerY.equalTo(lbAvailableT);
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
        make.left.right.equalTo(0);
        make.height.equalTo(0.5);
        make.bottom.equalTo(-40);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"当前委托", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(14)];
    [self addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(-10);
    }];
   
    UIButton *btnDealRecords = [UIButton buttonWithTitle:NSLocalizedString(@"成交记录", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(8) target:self selector:@selector(onBtnWithCheckDealRecordsEvent:)];
    [btnDealRecords setImage:[StatusHelper imageNamed:@"lite_kline_order"] forState:UIControlStateNormal];
    [self addSubview:btnDealRecords];
    [btnDealRecords makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50);
        make.height.equalTo(30);
        make.right.equalTo(-15);
        make.centerY.equalTo(lbTitle);
    }];
    [btnDealRecords setTitleRightSpace:5];
    
    self.symbols = @"BTC/USDT";
    self.dealWay = @"MARKET";
    self.matchType = @"BUY";
    self.matchBackgroundColor = kRGB(68, 188, 167);
}

- (void)timeAction {
    //定时器方法
    NSDictionary *params1 = @{@"symbol" : self.symbols,
                              @"type" : @"0"
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
    self.percent = 0.00;
    self.selectBtn.backgroundColor = [UIColor clearColor];
    [self.selectBtn setTitleColor:kRGB(16, 16, 16) forState:UIControlStateNormal];
    self.tfNumber.text = @"";
    self.tfPrice.text = @"";
    self.tfCommission.text = @"";
    
    NSString *unitFee = @"";
    if ([self.matchType isEqualToString:@"BUY"]) {
        unitFee = self.symbol;
    } else {
        unitFee = @"USDT";
    }
    self.lbFee.text = [NSString stringWithFormat:@"0.00000000 %@", unitFee];
}

- (void)setViewWithModel:(id)model {
    //币币页面信息
    if (model && [model isKindOfClass:[SymbolModel class]]) {
        SymbolModel *symbolModel = model;
        self.symbols = symbolModel.symbols;
        self.symbol = [symbolModel.symbols substringToIndex:symbolModel.symbols.length - 5];
        self.lbSymbol.text = self.symbol;
                
        self.available = [symbolModel.price floatValue];
        //手续费率
        self.feeRatio = [symbolModel.feeRate floatValue];
        //最小委托量
        self.minBuyNumber = [symbolModel.minBuyNumber floatValue];
        
        NSString *matchType = [symbolModel.matchType isEqualToString:@"BUY"] ? @"买入" : @"卖出";
        
        NSString *unitStr = @"";
        NSString *unitFee = @"";
        if ([symbolModel.matchType isEqualToString:@"BUY"]) {
            unitStr = @"USDT";
            unitFee = self.symbol;
        } else {
            unitStr = self.symbol;
            unitFee = @"USDT";
        }
        
        self.lbFee.text = [NSString stringWithFormat:@"0.00000000 %@", unitFee];
        
        self.lbAvailable.text = [NSString stringWithFormat:@"%.8f %@", [symbolModel.price floatValue], unitStr];
        
        [self.btnMethod setTitle:[NSString stringWithFormat:@"%@%@", NSLocalizedString(matchType, nil), self.symbol] forState:UIControlStateNormal];
        
        //[self calculateNumber];
        
        [self timeAction];
    }
}

- (void)setViewQuotesWithModel:(id)model {
    //当前币种行情
    if (model && [model isKindOfClass:[QuotesModel class]]) {
        QuotesModel *quotesModel = model;        
        //需要保留的小数点位数
        self.pointNumber = [quotesModel.number integerValue];
        NSString *format = [NSString stringWithFormat:@"%%.%ldf", self.pointNumber];
        self.lbNewPrice.text = [NSString stringWithFormat:format, [quotesModel.close floatValue]];
        
        self.lbRate.text = [NSString stringWithFormat:@"%.2f%%", [quotesModel.rose floatValue]];
        self.lbRate.textColor = [quotesModel.rose containsString:@"-"] ? kRedColor : kGreenColor;
    }
}

- (void)setViewQuotesDealInfoWithModel:(id)model {
    //币币交易信息
    if (model && [model isKindOfClass:[TradeListModel class]]) {
        TradeListModel *tradeListModel = model;
        NSMutableArray *arrayBids = [NSMutableArray arrayWithArray:tradeListModel.bids];
        __block CGFloat bidsArrayMax = 0;     //取买单最大的值
        if (tradeListModel.bids && [tradeListModel.bids count]) {
        //所有买单(从高到低)
            for (int i = 0; i < tradeListModel.bids.count; i ++) {
                NSArray *array = tradeListModel.bids[i];
                NSString *number = [NSString stringWithFormat:@"%@", array[1]];
                if ([NSString isEmpty:number]) {
                    number = @"0.00000000";
                }
                if (bidsArrayMax < [number floatValue]) {
                    //取出最大的价格数量
                    bidsArrayMax = [number floatValue];
                }
                //冒泡降序排序（6、5、4、3、2、1）
                for (int j = 0; j < tradeListModel.bids.count - 1 - i; j ++) {
                    if ([arrayBids[j][0] floatValue] < [arrayBids[j + 1][0] floatValue]) {
                        NSArray *array = arrayBids[j];
                        arrayBids[j] = arrayBids[j + 1];
                        arrayBids[j + 1] = array;
                    }
                }
            }
        }
        NSMutableArray *arrayAsks = [[NSMutableArray alloc] initWithArray:tradeListModel.asks];
        NSMutableArray *arrayAsks0 = [NSMutableArray arrayWithCapacity:5];
        NSArray *tempArray = [NSArray array];
        //取卖单最大的值
        __block CGFloat asksArrayMax = 0;
        
        if (tradeListModel.asks && [tradeListModel.asks count]) {
            //所有卖单（从高到低）
            for (int i = 0; i < tradeListModel.asks.count; i ++) {
                NSArray *array = tradeListModel.asks[i];
                NSString *number = [NSString stringWithFormat:@"%@", array[1]];
                if ([NSString isEmpty:number]) {
                    number = @"0.00000000";
                }
                if (asksArrayMax < [number floatValue]) {
                    //取出最大的价格数量
                    asksArrayMax = [number floatValue];
                }
                //冒泡升序排序（0、1、2、3、4、5、6）
                for (int j = 0; j < tradeListModel.asks.count - 1 - i; j ++) {
                    if ([arrayAsks[j + 1][0] floatValue] < [arrayAsks[j][0] floatValue]) {
                        NSArray *array = arrayAsks[j];
                        arrayAsks[j] = arrayAsks[j + 1];
                        arrayAsks[j + 1] = array;
                    }
                }
            }
            //取出前5个值
            [arrayAsks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < 5) {
                    [arrayAsks0 addObject:obj];
                }
            }];
            //倒序(5、4、3、2、1)
            tempArray = [[arrayAsks0 reverseObjectEnumerator] allObjects];
        }
        //取买单和卖单最大的值；
        self.buyTableView.maxNumber = bidsArrayMax;
        self.buyTableView.arrayTableDatas = arrayBids;
        self.buyTableView.type = @"buy";
        self.buyTableView.number = tradeListModel.number;

        self.sellTableView.maxNumber = asksArrayMax;
        self.sellTableView.arrayTableDatas = tempArray;
        self.sellTableView.type = @"sell";
        self.sellTableView.number = tradeListModel.number;
    }
}

#pragma mark - Setter & Getter
- (NSMutableArray<UIButton *> *)arrayMethodBtns {
    if (!_arrayMethodBtns) {
        _arrayMethodBtns = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayMethodBtns;
}

- (NSArray<NSString *> *)arrayMethodeBtnTitles {
    if (!_arrayMethodeBtnTitles) {
        _arrayMethodeBtnTitles = @[@"买入", @"卖出"];
    }
    return _arrayMethodeBtnTitles;
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

- (DropDownView *)dropDownView {
    if (!_dropDownView) {
        _dropDownView = [[DropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _dropDownView.arrayTableDatas = @[@"市价委托", @"限价委托"];
        WeakSelf
        [_dropDownView setOnDidSelectIndexBlock:^(id  _Nonnull obj) {
            NSString *title = obj;
            weakSelf.tfCommission.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(title, nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];;
            if ([title isEqualToString:@"市价委托"]) {
                weakSelf.tfPrice.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"市价", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
                weakSelf.tfPrice.enabled = NO;
                weakSelf.dealWay = @"MARKET";
                weakSelf.tfPrice.text = @"";
            } else {
                weakSelf.tfPrice.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"输入委托价格", nil) attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
                weakSelf.tfPrice.enabled = YES;
                weakSelf.dealWay = @"LIMIT";
            }
            
            [weakSelf calculateNumber];
            
            if (weakSelf.onDidSelectDealWayBlock) {
                weakSelf.onDidSelectDealWayBlock(weakSelf.dealWay);
            }
        }];
    }
    return _dropDownView;
}

@end
