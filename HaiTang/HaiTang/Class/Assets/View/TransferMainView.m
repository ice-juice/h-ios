//
//  TransferMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "TransferMainView.h"
#import "DropDownView.h"

#import "AssetsModel.h"
#import "AssetsMainViewModel.h"

@interface TransferMainView ()
@property (nonatomic, strong) UILabel *lbSymbol;
@property (nonatomic, strong) UILabel *lbFrom;
@property (nonatomic, strong) UILabel *lbTo;
@property (nonatomic, strong) UITextField *tfNumber;
@property (nonatomic, strong) UILabel *lbAvailable;
@property (nonatomic, strong) UILabel *lbSymbolLeft;

@property (nonatomic, strong) DropDownView *fromDropDownView;
@property (nonatomic, strong) DropDownView *toDropDownView;

@property (nonatomic, copy) NSString *availableAmount;     //可用余额

@property (nonatomic, copy) NSArray<NSString *> *arrayAccounts;

@end

@implementation TransferMainView
#pragma mark - Event Response
- (void)onBtnWithSelectSymbolEvent:(UIButton *)btn {
    //选择币种
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithSelectSymbol:)]) {
        [self.delegate performSelector:@selector(mainViewWithSelectSymbol:) withObject:self.lbSymbol.text];
    }
}

- (void)onBtnWithTransferEvent:(UIButton *)btn {
    //划转
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.lbFrom.text = [(AssetsMainViewModel *)self.mainViewModel to];
        self.lbTo.text = [(AssetsMainViewModel *)self.mainViewModel from];
    } else {
        self.lbFrom.text = [(AssetsMainViewModel *)self.mainViewModel from];
        self.lbTo.text = [(AssetsMainViewModel *)self.mainViewModel to];
    }
    [(AssetsMainViewModel *)self.mainViewModel setFrom:self.lbFrom.text];
    [(AssetsMainViewModel *)self.mainViewModel setTo:self.lbTo.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithTransferInfo)]) {
        [self.delegate performSelector:@selector(mainViewWithTransferInfo)];
    }
}

- (void)onBtnWithFromEvent:(UIButton *)btn {
    //从
    if ([self.lbSymbol.text isEqualToString:@"USDT"]) {
        [self.fromDropDownView showViewWithX:89 y:kNavBarHeight + 115 width:156 height:128];
    }
}

- (void)onBtnWithToEvent:(UIButton *)btn {
    //到
    if ([self.lbSymbol.text isEqualToString:@"USDT"]) {
        [self.toDropDownView showViewWithX:89 y:kNavBarHeight + 160 width:156 height:128];
    }
}

- (void)onBtnWithAllEvent:(UIButton *)btn {
    //全部
    self.tfNumber.text = self.availableAmount;
}

- (void)onBtnWithSubmitEvent:(UIButton *)btn {
    if ([NSString isEmpty:self.tfNumber.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入划转数量", nil) duration:2];
    }
    if ([self.tfNumber.text floatValue] <= 0) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入划转数量", nil) duration:2];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithSubmitTransfer:)]) {
        [self.delegate performSelector:@selector(mainViewWithSubmitTransfer:) withObject:self.tfNumber.text];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.lbSymbol = [UILabel labelWithText:@"USDT" textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:self.lbSymbol];
    [self.lbSymbol makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 20);
        make.left.equalTo(15);
    }];
    
    UIButton *btnSelectCoin = [UIButton buttonWithTitle:NSLocalizedString(@"选择划转币种", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithSelectSymbolEvent:)];
    [btnSelectCoin setImage:[UIImage imageNamed:@"xianyou"] forState:UIControlStateNormal];
    CGFloat btnW = [btnSelectCoin.titleLabel.text widthForFont:kFont(12) maxHeight:30] + 20;
    [self addSubview:btnSelectCoin];
    [btnSelectCoin makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(self.lbSymbol);
        make.width.equalTo(btnW);
        make.height.equalTo(30);
    }];
    [btnSelectCoin setTitleLeftSpace:10];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
        make.top.equalTo(btnSelectCoin.mas_bottom);
    }];
    
    UIView *selectView = [[UIView alloc] init];
    selectView.layer.cornerRadius = 4;
    selectView.layer.borderColor = kRGB(236, 236, 236).CGColor;
    selectView.layer.borderWidth = 0.5;
    [self addSubview:selectView];
    [selectView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(105);
    }];
    
    UIButton *btnTransfer = [UIButton buttonWithImageName:@"transfer_button" highlightedImageName:@"transfer_button" target:self selector:@selector(onBtnWithTransferEvent:)];
    btnTransfer.backgroundColor = kRGB(236, 236, 236);
    [selectView addSubview:btnTransfer];
    [btnTransfer makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(0);
        make.width.equalTo(100);
    }];
    
    UILabel *lbFromTitle = [UILabel labelWithText:NSLocalizedString(@"从", nil) textColor:kRGB(153, 153, 153) font:kBoldFont(14)];
    [selectView addSubview:lbFromTitle];
    [lbFromTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(30);
        make.top.equalTo(15);
    }];
    
    self.lbFrom = [UILabel labelWithText:NSLocalizedString(@"钱包账户", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [selectView addSubview:self.lbFrom];
    [self.lbFrom makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(74);
        make.centerY.equalTo(lbFromTitle);
    }];
    
    UIImageView *fromImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bibi-xl"]];
    [selectView addSubview:fromImgView];
    [fromImgView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(10);
        make.height.equalTo(14);
        make.right.equalTo(btnTransfer.mas_left).offset(-15);
        make.centerY.equalTo(lbFromTitle);
    }];
    
    UIButton *btnFrom = [UIButton buttonWithTarget:self selector:@selector(onBtnWithFromEvent:)];
    [selectView addSubview:btnFrom];
    [btnFrom makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(self.lbFrom);
        make.right.equalTo(fromImgView);
        make.height.equalTo(44);
    }];
    
    UIView *lineView0 = [[UIView alloc] init];
    lineView0.backgroundColor = kRGB(236, 236, 236);
    [selectView addSubview:lineView0];
    [lineView0 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(45);
        make.right.equalTo(fromImgView);
        make.height.equalTo(0.5);
    }];
    
    UILabel *lbToTitle = [UILabel labelWithText:NSLocalizedString(@"到", nil) textColor:kRGB(153, 153, 153) font:kBoldFont(14)];
    [selectView addSubview:lbToTitle];
    [lbToTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(30);
        make.top.equalTo(lineView0.mas_bottom).offset(15);
    }];
    
    self.lbTo = [UILabel labelWithText:NSLocalizedString(@"币币账户", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [selectView addSubview:self.lbTo];
    [self.lbTo makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(74);
        make.centerY.equalTo(lbToTitle);
    }];
    
    UIImageView *toImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bibi-xl"]];
    [selectView addSubview:toImgView];
    [toImgView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(10);
        make.height.equalTo(14);
        make.right.equalTo(btnTransfer.mas_left).offset(-15);
        make.centerY.equalTo(lbToTitle);
    }];
    
    UIButton *btnTo = [UIButton buttonWithTarget:self selector:@selector(onBtnWithToEvent:)];
    [selectView addSubview:btnTo];
    [btnTo makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView0.mas_bottom);
        make.left.equalTo(self.lbTo);
        make.right.equalTo(toImgView);
        make.height.equalTo(44);
    }];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = kRGB(236, 236, 236);
    [selectView addSubview:lineView1];
    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(lineView0.mas_bottom).offset(45);
        make.right.equalTo(toImgView);
        make.height.equalTo(0.5);
    }];
    
    UILabel *lbTransferTitle = [UILabel labelWithText:NSLocalizedString(@"划转数量", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbTransferTitle];
    [lbTransferTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectView.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    UIButton *btnAll = [UIButton buttonWithTitle:NSLocalizedString(@"全部  |", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(14) target:self selector:@selector(onBtnWithAllEvent:)];
    btnAll.frame = CGRectMake(0, 0, 42, 40);
    [rightView addSubview:btnAll];
    btnAll.titleLabel.attributedText = [btnAll.titleLabel.text attributedStringWithSubString:@"|" subColor:kRGB(16, 16, 16)];
    
    self.lbSymbolLeft = [UILabel labelWithText:@"USDT" textColor:kRGB(16, 16, 16) font:kFont(14)];
    self.lbSymbolLeft.frame = CGRectMake(42, 10, 58, 20);
    self.lbSymbolLeft.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:self.lbSymbolLeft];
    
    self.tfNumber = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入划转数量", nil) hasLine:YES];
    self.tfNumber.keyboardType = UIKeyboardTypePhonePad;
    self.tfNumber.rightView = rightView;
    self.tfNumber.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:self.tfNumber];
    [self.tfNumber makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(lbTransferTitle.mas_bottom).offset(5);
        make.height.equalTo(40);
    }];
    
    UILabel *lbAvailableTitle = [UILabel labelWithText:NSLocalizedString(@"可用余额：", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:lbAvailableTitle];
    [lbAvailableTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfNumber.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lbAvailable = [UILabel labelWithText:@"0.00000000 BTC" textColor:kRedColor font:kFont(12)];
    [self addSubview:self.lbAvailable];
    [self.lbAvailable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(lbAvailableTitle);
    }];
    
    UIButton *btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"确定", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSubmitEvent:)];
    btnSubmit.backgroundColor = kRGB(0, 102, 237);
    btnSubmit.layer.cornerRadius = 2;
    btnSubmit.custom_acceptEventInterval = 3;
    [self addSubview:btnSubmit];
    [btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbAvailableTitle.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

- (void)updateView {
    AssetsModel *assetsModel = [(AssetsMainViewModel *)self.mainViewModel transferInfoModel];
    self.lbSymbol.text = assetsModel.unit;
    self.lbSymbolLeft.text = assetsModel.unit;
    self.lbAvailable.text = [NSString stringWithFormat:@"%.8f %@", [assetsModel.price doubleValue], assetsModel.unit];
    self.availableAmount = assetsModel.price;
    
    NSString *from = [(AssetsMainViewModel *)self.mainViewModel from];
    NSString *to = [(AssetsMainViewModel *)self.mainViewModel to];
    self.lbFrom.text = from;
    self.lbTo.text = to;
    if ([self.lbSymbol.text isEqualToString:@"USDT"]) {
        self.arrayAccounts = @[@"钱包账户", @"币币账户", @"合约账户", @"法币账户"];
        NSMutableArray *arrayToDatas = [NSMutableArray arrayWithCapacity:3];
        NSMutableArray *arrayFromDatas = [NSMutableArray arrayWithCapacity:3];
        [self.arrayAccounts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:NSLocalizedString(from, nil)]) {
                [arrayToDatas addObject:obj];
            }
            if (![obj isEqualToString:NSLocalizedString(to, nil)]) {
                [arrayFromDatas addObject:obj];
            }
        }];
        self.fromDropDownView.arrayTableDatas = arrayFromDatas;
        self.toDropDownView.arrayTableDatas = arrayToDatas;
    }
}


#pragma mark - Setter & Getter
- (DropDownView *)fromDropDownView {
    if (!_fromDropDownView) {
        _fromDropDownView = [[DropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_fromDropDownView setOnDidSelectIndexBlock:^(id  _Nonnull obj) {
            NSString *title = obj;
            weakSelf.lbFrom.text = NSLocalizedString(title, nil);
            [(AssetsMainViewModel *)weakSelf.mainViewModel setFrom:title];
            if (![weakSelf.lbSymbol.text isEqualToString:@"USDT"]) {
                if ([weakSelf.lbFrom.text isEqualToString:NSLocalizedString(@"钱包账户", nil)]) {
                    [(AssetsMainViewModel *)weakSelf.mainViewModel setTo:NSLocalizedString(@"币币账户", nil)];
                } else {
                    [(AssetsMainViewModel *)weakSelf.mainViewModel setTo:NSLocalizedString(@"钱包账户", nil)];
                }
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithTransferInfo)]) {
                [weakSelf.delegate performSelector:@selector(mainViewWithTransferInfo)];
            }
        }];
    }
    return _fromDropDownView;
}

- (DropDownView *)toDropDownView {
    if (!_toDropDownView) {
        _toDropDownView = [[DropDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_toDropDownView setOnDidSelectIndexBlock:^(id  _Nonnull obj) {
            NSString *title = obj;
            weakSelf.lbTo.text = NSLocalizedString(title, nil);
            [(AssetsMainViewModel *)weakSelf.mainViewModel setTo:title];
            if (![weakSelf.lbSymbol.text isEqualToString:@"USDT"]) {
                if ([weakSelf.lbTo.text isEqualToString:NSLocalizedString(@"钱包账户", nil)]) {
                    [(AssetsMainViewModel *)weakSelf.mainViewModel setFrom:NSLocalizedString(@"币币账户", nil)];
                } else {
                    [(AssetsMainViewModel *)weakSelf.mainViewModel setFrom:NSLocalizedString(@"钱包账户", nil)];
                }
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mainViewWithTransferInfo)]) {
                [weakSelf.delegate performSelector:@selector(mainViewWithTransferInfo)];
            }
        }];
    }
    return _toDropDownView;
}


@end
