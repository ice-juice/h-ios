//
//  FilterPurchaseView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FilterPurchaseView.h"

@interface FilterPurchaseView ()
@property (nonatomic, strong) UITextField *tfMoney;
@property (nonatomic, strong) UITextField *tfNumber;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *btnAll;

@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, strong) NSMutableArray<NSString *> *arrayPaymentIndex;

@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;
@property (nonatomic, copy) NSArray<NSString *> *arrayPayments;

@end

@implementation FilterPurchaseView
#pragma mark - Event Response
- (void)onBtnWithSwitchPaymentEvent:(UIButton *)btn {
    //选择支付方式
    btn.selected = !btn.selected;
    btn.backgroundColor = btn.selected ? kRGB(0, 102, 237) : kRGB(236, 236, 236);
    self.btnAll.selected = NO;
    self.btnAll.backgroundColor = kRGB(236, 236, 236);
    [self.arrayPaymentIndex removeObject:@"全部"];
    
    NSInteger index = btn.tag - 1000;
    NSString *payment = self.arrayPayments[index];
    if (btn.selected) {
        [self.arrayPaymentIndex addObject:payment];
    } else {
        [self.arrayPaymentIndex removeObject:payment];
    }
}

- (void)onBtnWithSelectAllEvent:(UIButton *)btn {
    //全部
    btn.selected = YES;
    [self.arrayPaymentIndex removeAllObjects];
    if (btn.selected) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
            obj.backgroundColor = kRGB(236, 236, 236);
        }];
        btn.backgroundColor = kRGB(0, 102, 237);
        [self.arrayPaymentIndex addObject:@"全部"];
    }
}

- (void)onBtnWithResetEvent:(UIButton *)btn {
    //重置
    self.btnAll.selected = YES;
    self.btnAll.backgroundColor = kRGB(0, 102, 237);
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        obj.backgroundColor = kRGB(236, 236, 236);
    }];
    [self.arrayPaymentIndex removeAllObjects];
    self.tfMoney.text = @"";
    self.tfNumber.text = @"";
}

- (void)onBtnWithSureEvent:(UIButton *)btn {
    NSString *payment = [self.arrayPaymentIndex componentsJoinedByString:@","];
    NSString *number = self.tfNumber.text;
    NSString *price = self.tfMoney.text;
    if ([NSString isEmpty:payment] || [payment containsString:@"全部"]) {
        payment = @"";
    }
    if ([NSString isEmpty:self.tfMoney.text]) {
        price = @"";
    }
    if ([NSString isEmpty:self.tfNumber.text]) {
        number = @"";
    }
    if (self.onBtnWithFilterBlock) {
        self.onBtnWithFilterBlock(payment, price, number);
    }
    [self closeView];
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.1;
    backgroundView.userInteractionEnabled = YES;
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)]];
    [self addSubview:backgroundView];
    [backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(400);
    }];
    
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"筛选", nil) textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:20]];
    [self.contentView addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(52);
        make.left.equalTo(15);
    }];
    
    UILabel *lbSubTitle = [UILabel labelWithText:NSLocalizedString(@"支付方式", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self.contentView addSubview:lbSubTitle];
    [lbSubTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTitle.mas_bottom).offset(28);
        make.left.equalTo(15);
    }];
    
    self.btnAll = [UIButton buttonWithTitle:NSLocalizedString(@"全部", nil) titleColor:kRGB(153, 153, 153) highlightedTitleColor:kRGB(153, 153, 153) font:kFont(12) target:self selector:@selector(onBtnWithSelectAllEvent:)];
    self.btnAll.backgroundColor = kRGB(236, 236, 236);
    self.btnAll.layer.cornerRadius = 2;
    [self.btnAll setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.btnAll.backgroundColor = kRGB(0, 102, 237);
    self.btnAll.selected = YES;
    [self.contentView addSubview:self.btnAll];
    [self.btnAll makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(60);
        make.height.equalTo(24);
        make.top.equalTo(lbSubTitle.mas_bottom).offset(10);
    }];
    //2021-02-05
    lbSubTitle.hidden = YES;
    self.btnAll.hidden = YES;
    
    if (self.arrayBtns) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayBtns removeAllObjects];
    }
    
    CGFloat rowSpace = (kScreenWidth - ([self.arrayBtnTitles count] + 1) * 60) / ([self.arrayBtnTitles count] + 2);
    [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(153, 153, 153) highlightedTitleColor:kRGB(153, 153, 153) font:kFont(12) target:self selector:@selector(onBtnWithSwitchPaymentEvent:)];
        btn.tag = idx + 1000;
        btn.backgroundColor = kRGB(236, 236, 236);
        btn.layer.cornerRadius = 2;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //2021-02-05
        btn.hidden = YES;
        [self.contentView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbSubTitle.mas_bottom).offset(10);
            make.left.equalTo(rowSpace + idx * 60 + rowSpace * idx + 75);
            make.width.equalTo(60);
            make.height.equalTo(24);
        }];
        [self.arrayBtns addObject:btn];
    }];
    
    UILabel *lbMoney = [UILabel labelWithText:NSLocalizedString(@"金额", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self.contentView addSubview:lbMoney];
    [lbMoney makeConstraints:^(MASConstraintMaker *make) {
        //2021-02-05
//        make.top.equalTo(lbSubTitle.mas_bottom).offset(54);
        make.top.equalTo(lbTitle.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    UILabel *lbCNY = [UILabel labelWithText:@"USD" textColor:kRGB(0, 102, 237) font:kFont(12)];
    lbCNY.frame = CGRectMake(0, 10, 30, 20);
    self.tfMoney = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入购买金额", nil) hasLine:YES];
    self.tfMoney.keyboardType = UIKeyboardTypeDecimalPad;
    self.tfMoney.rightView = lbCNY;
    self.tfMoney.rightViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.tfMoney];
    [self.tfMoney makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbMoney.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UILabel *lbNumber = [UILabel labelWithText:NSLocalizedString(@"数量", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self.contentView addSubview:lbNumber];
    [lbNumber makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfMoney.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    UILabel *lbUSDT = [UILabel labelWithText:@"USDT" textColor:kRGB(0, 102, 237) font:kFont(12)];
    lbUSDT.frame = CGRectMake(0, 10, 35, 20);
    self.tfNumber = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入购买数量", nil) hasLine:YES];
    self.tfNumber.keyboardType = UIKeyboardTypeDecimalPad;
    self.tfNumber.rightView = lbUSDT;
    self.tfNumber.rightViewMode = UITextFieldViewModeAlways;
    [self.contentView addSubview:self.tfNumber];
    [self.tfNumber makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbNumber.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UIButton *btnReset = [UIButton buttonWithTitle:NSLocalizedString(@"重置", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnWithResetEvent:)];
    btnReset.layer.cornerRadius = 2;
    btnReset.layer.borderColor = kRGB(0, 102, 237).CGColor;
    btnReset.layer.borderWidth = 1;
    [self.contentView addSubview:btnReset];
    [btnReset makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(-21);
        make.width.equalTo((kScreenWidth - 55) / 2);
        make.height.equalTo(34);
    }];
    
    UIButton *btnSure = [UIButton buttonWithTitle:NSLocalizedString(@"确定", nil) titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(255, 255, 255) font:kFont(14) target:self selector:@selector(onBtnWithSureEvent:)];
    btnSure.layer.cornerRadius = 2;
    btnSure.backgroundColor = kRGB(0, 102, 237);
    [self.contentView addSubview:btnSure];
    [btnSure makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(-21);
        make.width.equalTo((kScreenWidth - 55) / 2);
        make.height.equalTo(34);
    }];
    
    [self.arrayPaymentIndex addObject:@"全部"];
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, -400, kScreenWidth, 400)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    }];
}

- (void)closeView {
//    WeakSelf
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 400)];
//
//    } completion:^(BOOL finished) {
//        [weakSelf removeFromSuperview];
//    }];
    [self removeFromSuperview];
}

#pragma mark - Setter & Getter
- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:5];
    }
    return _arrayBtns;
}

- (NSArray<NSString *> *)arrayBtnTitles {
    if (!_arrayBtnTitles) {
        _arrayBtnTitles = @[@"支付宝", @"微信", @"银行卡", @"PayPal"];
    }
    return _arrayBtnTitles;
}

- (NSArray<NSString *> *)arrayPayments {
    if (!_arrayPayments) {
        _arrayPayments = @[@"ALI_PAY", @"WE_CHAT", @"BANK", @"PAYPAL"];
    }
    return _arrayPayments;
}

- (NSMutableArray<NSString *> *)arrayPaymentIndex {
    if (!_arrayPaymentIndex) {
        _arrayPaymentIndex = [NSMutableArray arrayWithCapacity:5];
    }
    return _arrayPaymentIndex;
}

@end
