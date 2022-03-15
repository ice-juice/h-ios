//
//  OrderPopupView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/28.
//  Copyright © 2020 zy. All rights reserved.
//

#import "OrderPopupView.h"

#import "OrderModel.h"

@interface OrderPopupView ()<UITextFieldDelegate>
{
    BOOL isHaveDian;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbNumber;
@property (nonatomic, strong) UILabel *lbLimit;      //限额
@property (nonatomic, strong) UILabel *lbPrice;
@property (nonatomic, strong) UIImageView *imgViewPayMethod;
@property (nonatomic, strong) UITextField *tfMoney;
@property (nonatomic, strong) UIButton *btnBuyMethod;
@property (nonatomic, strong) UILabel *lbPayMoney;    //需付款
@property (nonatomic, strong) UIButton *btnAllBuy;

@property (nonatomic, strong) OrderModel *orderModel;

//购买方式 0-数量 1-金额(默认金额)
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation OrderPopupView
#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 450, self.frame.size.width, 332)];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 332, self.frame.size.width, 332)];
}

- (void)keyboardDidHide:(NSNotification*)aNotification {
    [self.contentView setFrame:CGRectMake(0, self.frame.size.height - 332, self.frame.size.width, 332)];
}

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
                    if (range.location - ran.location <= 8) {
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
- (void)onBtnBuyAllEvent:(UIButton *)btn {
    //全部买入
    self.tfMoney.text = self.orderModel.restNumber;
    
    CGFloat price = 0.00;
    if (self.selectIndex == 0) {
        //数量
        price = [self.tfMoney.text floatValue] * [self.orderModel.unitPrice floatValue];
    } else {
        price = self.tfMoney.text.floatValue;
    }
        
    self.lbPayMoney.text = [NSString stringWithFormat:@"需付款:%.2fUSD", price];
}

- (void)onBtnBuyMethodEvent:(UIButton *)btn {
    //购买方式
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.tfMoney.leftViewMode = UITextFieldViewModeNever;
        if ([self.orderModel.orderType isEqualToString:@"0"]) {
            //购买
            [self.btnAllBuy setTitle:@"USDT | 全部购买" forState:UIControlStateNormal];
            self.tfMoney.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%.2f", NSLocalizedString(@"最小购买数量", nil), [self.orderModel.lowPrice floatValue]] attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        } else {
            //出售
            [self.btnAllBuy setTitle:@"USDT | 全部出售" forState:UIControlStateNormal];
            self.tfMoney.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%.2f", NSLocalizedString(@"最小出售数量", nil), [self.orderModel.lowPrice floatValue]] attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        }
        self.selectIndex = 0;
    } else {
        self.tfMoney.leftViewMode = UITextFieldViewModeAlways;
        if ([self.orderModel.orderType isEqualToString:@"0"]) {
            //购买
            [self.btnAllBuy setTitle:@"USD | 全部购买" forState:UIControlStateNormal];
            self.tfMoney.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%.2f", NSLocalizedString(@"最小购买金额", nil), [self.orderModel.lowPrice floatValue]] attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        } else {
            //出售
            [self.btnAllBuy setTitle:@"USD | 全部出售" forState:UIControlStateNormal];
            self.tfMoney.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%.2f", NSLocalizedString(@"最小出售金额", nil), [self.orderModel.lowPrice floatValue]] attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        }
        self.selectIndex = 1;
    }
    self.tfMoney.text = @"";
    self.lbPayMoney.text = [NSString stringWithFormat:@"%@:0.00USD", NSLocalizedString(@"需付款", nil)];
}

- (void)onBtnCancelEvent:(UIButton *)btn {
    //取消
    [self closeView];
}

- (void)onBtnBuyEvent:(UIButton *)btn {
    //下单
    NSString *emptyText = self.selectIndex == 0 ? NSLocalizedString(@"请输入数量", nil) : NSLocalizedString(@"请输入金额", nil);
    NSString *lowPriceText = self.selectIndex == 0 ? NSLocalizedString(@"不能低于最小购买数量", nil) : NSLocalizedString(@"不能低于最小购买金额", nil);
    
    if ([NSString isEmpty:self.tfMoney.text] || [self.tfMoney.text floatValue] <= 0.0) {
        return [JYToastUtils showWithStatus:emptyText duration:2];
    }
    
    if ([self.tfMoney.text floatValue] < [self.orderModel.lowPrice floatValue]) {
        return [JYToastUtils showWithStatus:lowPriceText duration:2];
    }
    
    if ([self.orderModel.orderType isEqualToString:@"0"]) {
        //购买
        if (self.onBtnWithOrderBuyBlock) {
            self.onBtnWithOrderBuyBlock(self.orderModel.sellId, self.tfMoney.text, self.selectIndex);
        }
    } else {
        //出售
        if (self.onBtnWithOrderSellBlock) {
            self.onBtnWithOrderSellBlock(self.orderModel.buyId, self.tfMoney.text, self.selectIndex);
        }
    }
    [self closeView];
}

- (void)onTextFieldChangeValue:(UITextField *)textField {
    //需付款 = 单价 * 数量
    
    CGFloat price = 0.00;
    CGFloat number = [textField.text floatValue];
    if (self.selectIndex == 0) {
        //数量
        price = number * [self.orderModel.unitPrice floatValue];
    } else {
        price = number;
    }
    self.lbPayMoney.text = [NSString stringWithFormat:@"%@:%.2fUSD", NSLocalizedString(@"需付款", nil), price];
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.alpha = .1;
    backgroundView.backgroundColor = [UIColor blackColor];
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
        make.bottom.equalTo(15);
        make.height.equalTo(332);
    }];
    
    self.lbName = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:30]];
    [self.contentView addSubview:self.lbName];
    [self.lbName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
    }];
    
    self.lbNumber = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:self.lbNumber];
    [self.lbNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(self.lbName.mas_bottom).offset(20);
    }];
    
    self.lbLimit = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self.contentView addSubview:self.lbLimit];
    [self.lbLimit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbNumber.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbPrice = [UILabel labelWithText:@"" textColor:kRGB(3, 173, 143) font:kBoldFont(20)];
    [self.contentView addSubview:self.lbPrice];
    [self.lbPrice makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbName);
        make.right.equalTo(-15);
    }];
    
    self.imgViewPayMethod = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgViewPayMethod];
    [self.imgViewPayMethod makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24);
        make.top.equalTo(80);
        make.right.equalTo(-15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [self.contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
        make.top.equalTo(self.lbLimit.mas_bottom).offset(10);
    }];
    
    UILabel *lbSymbol = [UILabel labelWithText:@"$" textColor:kRGB(16, 16, 16) font:kBoldFont(20)];
    lbSymbol.textAlignment = NSTextAlignmentCenter;
    lbSymbol.frame = CGRectMake(0, 9, 20, 28);
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 42)];
    self.btnAllBuy = [UIButton buttonWithTitle:NSLocalizedString(@"USD | 全部买入", nil) titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kBoldFont(12) target:self selector:@selector(onBtnBuyAllEvent:)];
    self.btnAllBuy.frame = CGRectMake(0, 0, 100, 42);
    [rightView addSubview:self.btnAllBuy];
    
    self.tfMoney = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"最小金额500.00", nil) hasLine:YES];
    self.tfMoney.delegate = self;
    self.tfMoney.leftView = lbSymbol;
    self.tfMoney.rightView = rightView;
    self.tfMoney.keyboardType = UIKeyboardTypeDecimalPad;
    self.tfMoney.leftViewMode = UITextFieldViewModeAlways;
    self.tfMoney.rightViewMode = UITextFieldViewModeAlways;
    [self.tfMoney addTarget:self action:@selector(onTextFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.tfMoney];
    [self.tfMoney makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(15);
        make.right.equalTo(-14);
        make.height.equalTo(50);
    }];
    
    self.lbPayMoney = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kBoldFont(12)];
    [self.contentView addSubview:self.lbPayMoney];
    [self.lbPayMoney makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(-98);
    }];
    
    self.btnBuyMethod = [UIButton buttonWithTitle:NSLocalizedString(@"按数量购买", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnBuyMethodEvent:)];
    [self.btnBuyMethod setTitle:NSLocalizedString(@"按金额买入", nil) forState:UIControlStateSelected];
    [self.contentView addSubview:self.btnBuyMethod];
    [self.btnBuyMethod makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-19);
        make.top.equalTo(self.tfMoney.mas_bottom).offset(10);
        make.width.equalTo(65);
        make.height.equalTo(20);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithTitle:NSLocalizedString(@"取消", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(18) target:self selector:@selector(onBtnCancelEvent:)];
    btnCancel.layer.cornerRadius = 2;
    btnCancel.layer.borderColor = kRGB(0, 102, 237).CGColor;
    btnCancel.layer.borderWidth = 1;
    [self.contentView addSubview:btnCancel];
    [btnCancel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(-49);
        make.width.equalTo(150);
        make.height.equalTo(34);
    }];
    
    UIButton *btnOrder = [UIButton buttonWithTitle:NSLocalizedString(@"下单", nil) titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(255, 255, 255) font:kFont(18) target:self selector:@selector(onBtnBuyEvent:)];
    btnOrder.layer.cornerRadius = 2;
    btnOrder.backgroundColor = kRGB(0, 102, 237);
    [self.contentView addSubview:btnOrder];
    [btnOrder makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(-49);
        make.width.equalTo(150);
        make.height.equalTo(34);
    }];
    
    self.selectIndex = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[OrderModel class]]) {
        self.orderModel = model;
        self.paymentMethod = self.orderModel.payMethod;
        self.lbName.text = self.orderModel.nickName;
        self.lbPrice.text = [NSString stringWithFormat:@"$%.2f", [self.orderModel.unitPrice floatValue]];
        self.lbNumber.text = [NSString stringWithFormat:@"%@(USDT)：%.4f", NSLocalizedString(@"数量", nil), [self.orderModel.restNumber floatValue]];
        //限额范围，第一个数字=单笔最低购买(出售)金额，第二个数字=当前剩余数量*单价，单位CNY
        CGFloat min = [self.orderModel.lowPrice floatValue];
        CGFloat max = [self.orderModel.restNumber floatValue] * [self.orderModel.unitPrice floatValue];
        self.lbLimit.text = [NSString stringWithFormat:@"%@(USD)：%.4f-%.4f", NSLocalizedString(@"限额", nil), min, max];
        self.imgViewPayMethod.image = [UIImage imageNamed:self.orderModel.payMethodImgName];
        
        self.lbPayMoney.text = [NSString stringWithFormat:@"%@:0.00USD", NSLocalizedString(@"需付款", nil)];
        self.btnBuyMethod.selected = NO;
        self.selectIndex = 1;  //默认金额
        if ([self.orderModel.orderType isEqualToString:@"0"]) {
            //购买
            self.lbPrice.textColor = kRGB(3, 173, 143);
            [self.btnAllBuy setTitle:@"USD | 全部购买" forState:UIControlStateNormal];
            [self.btnBuyMethod setTitle:NSLocalizedString(@"按数量购买", nil) forState:UIControlStateNormal];
            [self.btnBuyMethod setTitle:NSLocalizedString(@"按金额购买", nil) forState:UIControlStateSelected];
            self.tfMoney.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%.2f", NSLocalizedString(@"最小购买金额", nil), [self.orderModel.lowPrice floatValue]] attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        } else {
            //出售
            self.lbPrice.textColor = kRGB(205, 61, 88);
            [self.btnAllBuy setTitle:@"USD | 全部出售" forState:UIControlStateNormal];
            [self.btnBuyMethod setTitle:NSLocalizedString(@"按数量出售", nil) forState:UIControlStateNormal];
            [self.btnBuyMethod setTitle:NSLocalizedString(@"按金额出售", nil) forState:UIControlStateSelected];
            self.tfMoney.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%.2f", NSLocalizedString(@"最小出售金额", nil), [self.orderModel.lowPrice floatValue]] attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
        }
        [self showView];
    }
}

- (void)showView {
    self.tfMoney.text = @"";
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.contentView setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 332)];
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(0, kScreenHeight - 317, kScreenWidth, 332)];
    }];
}

- (void)closeView {
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
