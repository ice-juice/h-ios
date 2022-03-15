//
//  PendingOrderBuyMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PendingOrderBuyMainView.h"

#import "FiatMainViewModel.h"

@interface PendingOrderBuyMainView ()
@property (nonatomic, strong) UITextField *tfPrice;          //购买单价
@property (nonatomic, strong) UITextField *tfNumber;         //购买数量
@property (nonatomic, strong) UITextField *tfMinNumber;      //单笔最小购买数量
@property (nonatomic, strong) UITextField *tfMinAmount;      //单笔最小购买金额

@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnImageNames;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation PendingOrderBuyMainView
#pragma mark - Event Response
- (void)onBtnWithSelectPaymentEvent:(UIButton *)btn {
    //选择付款方式
    if (btn.selected) {
        return;
    }
    self.selectIndex = btn.tag - 1000;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.selectIndex) {
            obj.selected = YES;
            obj.layer.borderColor = kRGB(0, 102, 237).CGColor;
        } else {
            obj.selected = NO;
            obj.layer.borderColor = kRGB(236, 236, 236).CGColor;
        }
    }];
}

- (void)onBtnWithSubmitEvent:(UIButton *)btn {
    //提交下单
    if ([NSString isEmpty:self.tfPrice.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入单价", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfNumber.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入数量", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfMinAmount.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入最小购买金额", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfMinNumber.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入最小购买数量", nil) duration:2];
    }
    [(FiatMainViewModel *)self.mainViewModel setPrice:self.tfPrice.text];
    [(FiatMainViewModel *)self.mainViewModel setNumber:self.tfNumber.text];
    [(FiatMainViewModel *)self.mainViewModel setLowNumber:self.tfMinNumber.text];
    [(FiatMainViewModel *)self.mainViewModel setLowPrice:self.tfMinAmount.text];
    [(FiatMainViewModel *)self.mainViewModel setPayMethod:self.arrayBtnTitles[self.selectIndex]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitOrder)]) {
        [self.delegate performSelector:@selector(submitOrder)];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = kRGB(248, 248, 248);
    [self addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(40);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"购买币种", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [topView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(15);
    }];
    
    UILabel *lbUsdt = [UILabel labelWithText:@"USDT" textColor:kRGB(0, 102, 237) font:kBoldFont(14)];
    [topView addSubview:lbUsdt];
    [lbUsdt makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(-15);
    }];
    
    UIView *priceView = [self createViewWithTitle:@"购买单价" rightViewText:@"USD" index:0];
    [self addSubview:priceView];
    [priceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    
    UIView *numerView = [self createViewWithTitle:@"购买数量" rightViewText:@"USDT" index:1];
    [self addSubview:numerView];
    [numerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    
    UIView *minNumerView = [self createViewWithTitle:@"单笔最小购买数量" rightViewText:@"USDT" index:2];
    [self addSubview:minNumerView];
    [minNumerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numerView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    
    UIView *minAmountView = [self createViewWithTitle:@"单笔最小购买金额" rightViewText:@"USD" index:3];
    [self addSubview:minAmountView];
    [minAmountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minNumerView.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(80);
    }];
    
    UILabel *lbPayment = [UILabel labelWithText:NSLocalizedString(@"选择付款方式", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbPayment];
    [lbPayment makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minAmountView.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    if (self.arrayBtns) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayBtns removeAllObjects];
    }
    CGFloat btnW = (kScreenWidth - 54) / 4;
    CGFloat btnH = 32;
    [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithSelectPaymentEvent:)];
        [btn setImage:[UIImage imageNamed:self.arrayBtnImageNames[idx]] forState:UIControlStateNormal];
        btn.tag = idx + 1000;
        btn.layer.cornerRadius = 2;
        btn.layer.borderColor = kRGB(236, 236, 236).CGColor;
        btn.layer.borderWidth = 0.5;
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15 + btnW * idx + 8 * idx);
            make.top.equalTo(lbPayment.mas_bottom).offset(10);
            make.width.equalTo(btnW);
            make.height.equalTo(btnH);
        }];
        [btn setTitleRightSpace:5];
        [self.arrayBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
            btn.layer.borderColor = kRGB(0, 102, 237).CGColor;
        }
    }];
    
    UIButton *btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"提交下单", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSubmitEvent:)];
    btnSubmit.backgroundColor = kRGB(0, 102, 237);
    btnSubmit.layer.cornerRadius = 4;
    [self addSubview:btnSubmit];
    [btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbPayment.mas_bottom).offset(82);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

- (void)updateView {
    self.tfPrice.text = @"";
    self.tfNumber.text = @"";
    self.tfMinAmount.text = @"";
    self.tfMinNumber.text = @"";
}

- (UIView *)createViewWithTitle:(NSString *)title rightViewText:(NSString *)rightViewText index:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(title, nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [view addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
    }];
    
    UILabel *lbRight = [UILabel labelWithText:rightViewText textColor:kRGB(16, 16, 16) font:kFont(14)];
    lbRight.frame = CGRectMake(0, 0, 40, 20);
    lbRight.textAlignment = NSTextAlignmentRight;
    
    UITextField *textField = [[UITextField alloc] initNoLeftViewWithPlaceHolder:@"0.00" hasLine:YES];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.rightView = lbRight;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [view addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    if (index == 0) {
        //购买单价
        self.tfPrice = textField;
    } else if (index == 1) {
        //购买数量
        self.tfNumber = textField;
    } else if (index == 2) {
        //最小购买数量
        self.tfMinNumber = textField;
    } else {
        //最小购买金额
        self.tfMinAmount = textField;
    }
    
    return view;
}

#pragma mark - Setter & Getter
- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:4];
    }
    return _arrayBtns;
}

- (NSArray<NSString *> *)arrayBtnTitles {
    if (!_arrayBtnTitles) {
        _arrayBtnTitles = @[@"银行卡"];
    }
    return _arrayBtnTitles;
}

- (NSArray<NSString *> *)arrayBtnImageNames {
    if (!_arrayBtnImageNames) {
        _arrayBtnImageNames = @[@"yhk"];
    }
    return _arrayBtnImageNames;
}

@end
