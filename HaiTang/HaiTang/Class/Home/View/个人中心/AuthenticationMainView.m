//
//  AuthenticationMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AuthenticationMainView.h"
#import "SelectCardTypeView.h"

#import "HomeMainViewModel.h"

@interface AuthenticationMainView ()
@property (nonatomic, strong) UILabel *lbType;
@property (nonatomic, strong) UITextField *tfAccount;
@property (nonatomic, strong) UITextField *tfXing;
@property (nonatomic, strong) UITextField *tfMing;

@property (nonatomic, strong) SelectCardTypeView *selectTypeView;

@end

@implementation AuthenticationMainView
#pragma mark - Event Response
- (void)onBtnWithDropDownEvent:(UIButton *)btn {
    //选择证件类型
    [self.selectTypeView showView];
}

- (void)onBtnWithNextEvent:(UIButton *)btn {
    //下一步
    if ([NSString isEmpty:self.tfAccount.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入您的证件号码", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfXing.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入您的姓氏", nil) duration:2];
    }
    if ([NSString isEmpty:self.tfMing.text]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入您的名字", nil) duration:2];
    }
    [(HomeMainViewModel *)self.mainViewModel setIdCard:self.tfAccount.text];
    [(HomeMainViewModel *)self.mainViewModel setFistName:self.tfXing.text];
    [(HomeMainViewModel *)self.mainViewModel setLastName:self.tfMing.text];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithType:withAccount:withXing:withMing:)]) {
//        [[NSInvocation invocationWithTarget:self.delegate selector:@selector(mainViewWithType:withAccount:withXing:withMing:) params:@[self.lbType.text, self.tfAccount.text, self.tfMing.text, self.tfXing.text]] invoke];
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithNext)]) {
        [self.delegate performSelector:@selector(mainViewWithNext)];
    }
}

#pragma mark - Super cLASS
- (void)setupSubViews {
    UILabel *lbTypeTitle = [UILabel labelWithText:NSLocalizedString(@"证件类型", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbTypeTitle];
    [lbTypeTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 20);
        make.left.equalTo(15);
    }];
    
    self.lbType = [UILabel labelWithText:NSLocalizedString(@"身份证", nil) textColor:kRGB(16, 16, 16) font:kFont(12)];
    [self addSubview:self.lbType];
    [self.lbType makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTypeTitle.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    UIButton *btnDown = [UIButton buttonWithImageName:@"bibi-xl" highlightedImageName:@"bibi-xl" target:self selector:@selector(onBtnWithDropDownEvent:)];
    [self addSubview:btnDown];
    [btnDown makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(40);
        make.right.equalTo(-15);
        make.centerY.equalTo(self.lbType);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTypeTitle.mas_bottom).offset(40);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
    }];
    
    UILabel *lbAccountTitle = [UILabel labelWithText:NSLocalizedString(@"证件号码", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbAccountTitle];
    [lbAccountTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    self.tfAccount = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入您的证件号码", nil) hasLine:YES];
    self.tfAccount.keyboardType = UIKeyboardTypeAlphabet;
    [self addSubview:self.tfAccount];
    [self.tfAccount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbAccountTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UILabel *lbXingTitle = [UILabel labelWithText:NSLocalizedString(@"姓", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbXingTitle];
    [lbXingTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfAccount.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    self.tfXing = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入您的姓氏", nil) hasLine:YES];
    [self addSubview:self.tfXing];
    [self.tfXing makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbXingTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UILabel *lbMingTitle = [UILabel labelWithText:NSLocalizedString(@"名", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [self addSubview:lbMingTitle];
    [lbMingTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfXing.mas_bottom).offset(20);
        make.left.equalTo(15);
    }];
    
    self.tfMing = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入您的名字", nil) hasLine:YES];
    [self addSubview:self.tfMing];
    [self.tfMing makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbMingTitle.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(40);
    }];
    
    UIButton *btnNext = [UIButton buttonWithTitle:NSLocalizedString(@"下一步", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithNextEvent:)];
    btnNext.backgroundColor = kRGB(0, 102, 237);
    btnNext.layer.cornerRadius = 4;
    [self addSubview:btnNext];
    [btnNext makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfMing.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
}

#pragma mark - Setter & Getter
- (SelectCardTypeView *)selectTypeView {
    if (!_selectTypeView) {
        _selectTypeView = [[SelectCardTypeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        WeakSelf
        [_selectTypeView setOnSelectCardTypeBlock:^(NSString * _Nonnull title) {
            //选择证件类型
            weakSelf.lbType.text = NSLocalizedString(title, nil);
            [(HomeMainViewModel *)weakSelf.mainViewModel setCardType:title];
        }];
    }
    return _selectTypeView;
}

@end
