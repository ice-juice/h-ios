//
//  KLineTableHeaderView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "KLineTableHeaderView.h"
#import "SelectTimeView.h"

#import "QuotesModel.h"
#import "KLineMainViewModel.h"

@interface KLineTableHeaderView ()
@property (nonatomic, strong) UILabel *lbPrice;        //最新行情价
@property (nonatomic, strong) UILabel *lbRate;         //涨跌幅
@property (nonatomic, strong) UILabel *lbCNY;          //≈¥
@property (nonatomic, strong) UILabel *lb24HHigh;      //24H高
@property (nonatomic, strong) UILabel *lb24HLow;       //24H低
@property (nonatomic, strong) UILabel *lbVolume;       //持仓量
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) UIButton *btnZhiBiao;
@property (nonatomic, strong) SelectTimeView *moreView;
@property (nonatomic, strong) SelectTimeView *zhiBiaoView;

@property (nonatomic, copy) NSArray<NSString *> *arrayBtnsTitle;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;

@end

@implementation KLineTableHeaderView
#pragma mark - Event Response
- (void)onBtnSelectTimeEvent:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDidSelectTimeAtIndex:)]) {
        [self.delegate performSelector:@selector(onDidSelectTimeAtIndex:) withObject:[NSString stringWithFormat:@"%ld", index]];
    }
}

- (void)onBtnSelectMoreEvent:(UIButton *)btn {
    btn.selected = YES;
    //更多
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    self.btnZhiBiao.selected = NO;
    
    [self.moreView showViewWithX:(kScreenWidth / 8) * 5 withY:152 + kNavBarHeight - self.scrollValue];
}

- (void)onBtnSelectZhiBiaoEvent:(UIButton *)btn {
    btn.selected = YES;
    //指标
//    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.selected = NO;
//    }];
//    self.btnMore.selected = NO;
    [self.zhiBiaoView showViewWithX:(kScreenWidth / 8) * 6 withY:152 + kNavBarHeight - self.scrollValue];
}

- (void)onBtnSelectScanEvent:(UIButton *)btn {
    
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(3, 14, 30);
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = kRGB(10, 22, 39);
    [self addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(105);
    }];
    
    UILabel *lb24HHigh = [UILabel labelWithText:[NSString stringWithFormat:@"24H%@", NSLocalizedString(@"高", nil)] textColor:kRGB(64, 146, 255) font:kFont(12)];
    [contentView addSubview:lb24HHigh];
    [lb24HHigh makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(16);
    }];
    
    UILabel *lb24HLow = [UILabel labelWithText:[NSString stringWithFormat:@"24H%@", NSLocalizedString(@"低", nil)] textColor:kRGB(64, 146, 255) font:kFont(12)];
    [contentView addSubview:lb24HLow];
    [lb24HLow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb24HHigh.mas_bottom).offset(10);
        make.left.equalTo(lb24HHigh);
    }];
    
    UILabel *lb24Amount = [UILabel labelWithText:NSLocalizedString(@"持仓量", nil) textColor:kRGB(64, 146, 255) font:kFont(12)];
    [contentView addSubview:lb24Amount];
    [lb24Amount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lb24HLow.mas_bottom).offset(10);
        make.left.equalTo(lb24HLow);
    }];
    
    self.lbPrice = [UILabel labelWithText:@"" textColor:[UIColor whiteColor] font:kBoldFont(24)];
    [contentView addSubview:self.lbPrice];
    [self.lbPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(19);
    }];
    
    self.lbRate = [UILabel labelWithText:@"" textColor:kGreenColor font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18]];
    [contentView addSubview:self.lbRate];
    [self.lbRate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbPrice).offset(4.5);
        make.left.equalTo(self.lbPrice.mas_right).offset(10);
    }];
    
    self.lbCNY = [UILabel labelWithText:@"" textColor:kRGB(125, 145, 171) font:kFont(14)];
    [contentView addSubview:self.lbCNY];
    [self.lbCNY makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbPrice.mas_bottom);
        make.left.equalTo(self.lbPrice);
    }];
    
    self.lb24HHigh = [UILabel labelWithText:@"" textColor:kRGB(255, 255, 255) font:kFont(14)];
    [contentView addSubview:self.lb24HHigh];
    [self.lb24HHigh makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lb24HHigh);
        make.right.equalTo(-16);
    }];
    
    self.lb24HLow = [UILabel labelWithText:@"" textColor:kRGB(255, 255, 255) font:kFont(14)];
    [contentView addSubview:self.lb24HLow];
    [self.lb24HLow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lb24HLow);
        make.right.equalTo(-16);
    }];
    
    self.lbVolume = [UILabel labelWithText:@"" textColor:kRGB(255, 255, 255) font:kFont(14)];
    [contentView addSubview:self.lbVolume];
    [self.lbVolume makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lb24Amount);
        make.right.equalTo(-15);
        make.left.equalTo(lb24Amount.mas_right).offset(25);
    }];
    
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = kRGB(10, 22, 39);
    [self addSubview:buttonView];
    [buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(15);
        make.left.right.equalTo(0);
        make.height.equalTo(32);
    }];
    
    if (self.arrayBtns) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayBtns removeAllObjects];
    }
    
    CGFloat btnW = kScreenWidth / 8;
    [self.arrayBtnsTitle enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(obj, nil) titleColor:kRGB(255, 255, 255) highlightedTitleColor:kRGB(255, 255, 255) font:kFont(12) target:self selector:@selector(onBtnSelectTimeEvent:)];
        [btn setTitleColor:kRGB(64, 146, 255) forState:UIControlStateSelected];
        btn.tag = 1000 + idx;
        [buttonView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnW * idx);
            make.width.equalTo(btnW);
            make.height.equalTo(32);
            make.centerY.equalTo(0);
        }];
        [self.arrayBtns addObject:btn];
        if (idx == 1) {
            btn.selected = YES;
        }
    }];
    
    self.btnMore = [UIButton buttonWithTitle:NSLocalizedString(@"更多", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(12) target:self selector:@selector(onBtnSelectMoreEvent:)];
    [self.btnMore setImage:[UIImage imageNamed:@"hyxq-xb"] forState:UIControlStateNormal];
    [self.btnMore setTitleColor:kRGB(64, 146, 255) forState:UIControlStateSelected];
    [buttonView addSubview:self.btnMore];
    [self.btnMore makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5 * btnW);
        make.height.equalTo(32);
        make.centerY.equalTo(0);
        make.width.equalTo(btnW);
    }];
    [self.btnMore setTitleLeftSpace:2];
    
    self.btnZhiBiao = [UIButton buttonWithTitle:NSLocalizedString(@"指标", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(12) target:self selector:@selector(onBtnSelectZhiBiaoEvent:)];
    [self.btnZhiBiao setTitleColor:kRGB(64, 146, 255) forState:UIControlStateSelected];
    [self.btnZhiBiao setImage:[UIImage imageNamed:@"hyxq-xb"] forState:UIControlStateNormal];
    [buttonView addSubview:self.btnZhiBiao];
    [self.btnZhiBiao makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnMore.mas_right);
        make.height.centerY.equalTo(self.btnMore);
        make.width.equalTo(btnW);
    }];
    [self.btnZhiBiao setTitleLeftSpace:10];
    
    UIButton *btnScan = [UIButton buttonWithImageName:@"hyxq-kk" highlightedImageName:@"hyxq-kk" target:self selector:@selector(onBtnSelectScanEvent:)];
    [buttonView addSubview:btnScan];
    [btnScan makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(0);
        make.height.equalTo(self.btnZhiBiao);
        make.width.equalTo(btnW);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[QuotesModel class]]) {
        QuotesModel *quotesModel = model;
        //需要限制小数点位数
        NSInteger pointNumber = [quotesModel.number integerValue];
        NSString *format = [NSString stringWithFormat:@"%%.%ldf", pointNumber];
        self.lbPrice.text = [NSString stringWithFormat:format, [quotesModel.close floatValue]];
        
        UIColor *textColor = [quotesModel.rose containsString:@"-"] ? kRGB(205, 61, 88) : kGreenColor;
        self.lbRate.text = [NSString stringWithFormat:@"%.2f%%", [quotesModel.rose floatValue]];
        self.lbRate.textColor = textColor;
        
        //2020-02-05
        self.lbCNY.text = [NSString stringWithFormat:@"≈$%.2f", [quotesModel.cny floatValue]];
        
        self.lb24HHigh.text = [NSString stringWithFormat:@"%.1f", [quotesModel.high floatValue]];
        
        self.lb24HLow.text = [NSString stringWithFormat:@"%.1f", [quotesModel.low floatValue]];
        
        self.lbVolume.text = [NSString stringWithFormat:@"%.1f", [quotesModel.amount floatValue]];
    }
}

- (void)updateView {
    [self setViewWithModel:[(KLineMainViewModel *)self.mainViewModel currentQuotesModel]];
}

#pragma mark - Setter & Getter
- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:5];
    }
    return _arrayBtns;
}

- (NSArray<NSString *> *)arrayBtnsTitle {
    if (!_arrayBtnsTitle) {
        _arrayBtnsTitle = @[@"分时", @"15分", @"1小时", @"4小时", @"一天"];
    }
    return _arrayBtnsTitle;
}

- (SelectTimeView *)moreView {
    if (!_moreView) {
        _moreView = [[SelectTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _moreView.arrayTableDatas = @[@"1分", @"5分", @"30分", @"1周", @"1月"];
        WeakSelf
        [_moreView setOnSelectRowAtIndex:^(NSInteger index) {
            [weakSelf.btnMore setTitle:weakSelf.moreView.arrayTableDatas[index] forState:UIControlStateNormal];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onDidSelectMoreAtIndex:)]) {
                [weakSelf.delegate performSelector:@selector(onDidSelectMoreAtIndex:) withObject:[NSString stringWithFormat:@"%ld", index]];
            }
        }];
        [_moreView setOnCloseViewBlock:^{
            weakSelf.btnMore.selected = NO;
        }];
    }
    return _moreView;
}

- (SelectTimeView *)zhiBiaoView {
    if (!_zhiBiaoView) {
        _zhiBiaoView = [[SelectTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _zhiBiaoView.arrayTableDatas = @[@"MACD", @"EMA", @"BOLL", @"KDJ"];
        WeakSelf
        [_zhiBiaoView setOnSelectRowAtIndex:^(NSInteger index) {
            [weakSelf.btnZhiBiao setTitle:weakSelf.zhiBiaoView.arrayTableDatas[index] forState:UIControlStateNormal];
            [weakSelf.btnZhiBiao setTitleLeftSpace:10];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onDidSelectZhiBiaoAtIndex:)]) {
                [weakSelf.delegate performSelector:@selector(onDidSelectZhiBiaoAtIndex:) withObject:[NSString stringWithFormat:@"%ld", index]];
            }
        }];
        [_zhiBiaoView setOnCloseViewBlock:^{
            weakSelf.btnZhiBiao.selected = NO;
        }];
    }
    return _zhiBiaoView;
}

@end
