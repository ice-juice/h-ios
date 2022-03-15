//
//  AppealMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/28.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AppealMainView.h"
#import "BaseCollectionViewCell.h"

#import "FiatMainViewModel.h"

@interface AppealMainView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;

@property (nonatomic, strong) NSMutableArray *arrayCollectionDatas;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation AppealMainView
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrayCollectionDatas count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = [BaseCollectionViewCell cellWithCollectionView:collectionView withIndexPath:indexPath];
    
    [cell.contentView removeAllSubviews];
    
    UIImageView *imageView = [[UIImageView alloc] init];   //WithImage:[UIImage imageNamed:@"feedback_image"]
    imageView.layer.cornerRadius = 3;
    imageView.clipsToBounds = YES;
    
    [cell.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    if (indexPath.item < [self.arrayCollectionDatas count]) {
        NSString *imgName = self.arrayCollectionDatas[indexPath.item];
        if ([imgName isEqualToString:kCameraImageName]) {
            [imageView setImage:[StatusHelper imageNamed:@"sctp"]];
        } else {
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, self.arrayCollectionDatas[indexPath.item]];
            [imageView setImageURL:[NSURL URLWithString:imgUrl]];
        }
        NSMutableArray *arrayUrls = [NSMutableArray arrayWithArray:self.arrayCollectionDatas];
        if ([arrayUrls containsObject:kCameraImageName]) {
            [arrayUrls removeObject:kCameraImageName];
        }
        NSString *imageUrls = [arrayUrls componentsJoinedByString:@","];
        [(FiatMainViewModel *)self.mainViewModel setImgUrls:imageUrls];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collection:didSelectIndex:)]) {
        [self.delegate performSelector:@selector(collection:didSelectIndex:) withObject:collectionView withObject:@(indexPath.item)];
    }
}

#pragma mark - Event Response
- (void)onBtnWithSelectReasonEvent:(UIButton *)btn {
    //选择申诉理由
    if (btn.selected) {
        return;
    }
    self.selectIndex = btn.tag - 1000;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.selectIndex == idx) {
            obj.selected = YES;
        } else {
            obj.selected = NO;
        }
    }];
    self.textView.editable = self.selectIndex == 0 ? NO : YES;
}

- (void)onBtnWithSubmitEvent:(UIButton *)btn {
    //提交申诉
    NSString *content = self.textView.text;
    if (self.selectIndex == 1) {
        if ([NSString isEmpty:content]) {
            return [JYToastUtils showWithStatus:NSLocalizedString(@"请输入申诉理由", nil) duration:2];
        }
    } else {
        content = [self.orderType isEqualToString:@"BUY"] ? @"我已付款，卖家未放币" : @"未收到买家付款款项，买家要求放币";
    }
    NSString *imgUrls = [(FiatMainViewModel *)self.mainViewModel imgUrls];
    if ([NSString isEmpty:imgUrls]) {
        return [JYToastUtils showWithStatus:NSLocalizedString(@"请上传凭证", nil) duration:2];
    }
    [(FiatMainViewModel *)self.mainViewModel setContent:NSLocalizedString(content, nil)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitAppeal)]) {
        [self.delegate performSelector:@selector(submitAppeal)];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"申诉理由", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(16)];
    [self addSubview:lbTitle];
    [lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 20);
        make.left.equalTo(15);
    }];
    
    self.textView = [[YYTextView alloc] init];
    self.textView.placeholderText = NSLocalizedString(@"请输入您的申诉理由", nil);
    self.textView.placeholderFont = kFont(12);
    self.textView.placeholderTextColor = kRGB(153, 153, 153);
    self.textView.font = kFont(12);
    self.textView.textColor = kRGB(16, 16, 16);
    self.textView.layer.cornerRadius = 2;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = kRGB(236, 236, 236).CGColor;
    self.textView.editable = NO;
    [self addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight + 140);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(100);
    }];
    
    UILabel *lbUploadTitle = [UILabel labelWithText:NSLocalizedString(@"上传凭证", nil) textColor:kRGB(16, 16, 16) font:kBoldFont(16)];
    [self addSubview:lbUploadTitle];
    [lbUploadTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbUploadTitle.mas_bottom).offset(15);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(100);
    }];
    
    UILabel *lbTip = [UILabel labelWithText:NSLocalizedString(@"请上传您的申诉凭证", nil) textColor:kRGB(205, 61, 88) font:kBoldFont(12)];
    [self addSubview:lbTip];
    [lbTip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
    }];
    
    UIButton *btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"提交申诉", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithSubmitEvent:)];
    btnSubmit.backgroundColor = kRGB(0, 102, 237);
    btnSubmit.layer.cornerRadius = 4;
    [self addSubview:btnSubmit];
    [btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbTip.mas_bottom).offset(40);
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.height.equalTo(30);
    }];
    [self.arrayCollectionDatas addObject:kCameraImageName];
}

- (void)updateView {
    if ([self.orderType isEqualToString:@"BUY"]) {
        //购买订单-卖家
        self.arrayBtnTitles = @[@"我已付款，卖家未放币", @"其他理由"];
    } else {
        //出售订单-卖家
        self.arrayBtnTitles = @[@"未收到买家付款款项，买家要求放币", @"其他理由"];
    }
    
    if (self.arrayBtns) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayBtns removeAllObjects];
    }
    [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:obj titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(12) target:self selector:@selector(onBtnWithSelectReasonEvent:)];
        [btn setImage:[UIImage imageNamed:@"zctk-wxz-2"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"zctk-wxz-1"] forState:UIControlStateSelected];
        btn.tag = 1000 + idx;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kNavBarHeight + 58 + 30 * idx + 10 * idx);
            make.left.equalTo(30);
            make.width.equalTo(250);
            make.height.equalTo(30);
        }];
        [btn setTitleRightSpace:10];
        [self.arrayBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
        }
    }];
}

- (void)updateImageView {
    [[(FiatMainViewModel *)self.mainViewModel arrayImageUrls] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCollectionDatas removeLastObject];
        if (![self.arrayCollectionDatas containsObject:obj]) {
            [self.arrayCollectionDatas addObject:obj];
        }
        if ([self.arrayCollectionDatas count] < 3) {
            [self.arrayCollectionDatas addObject:kCameraImageName];
        }
    }];
    
    [self.collectionView reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - Setter & Getter
- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayBtns;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10; //左右间距
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[BaseCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BaseCollectionViewCell class])];
    }
    return _collectionView;
}

- (NSMutableArray *)arrayCollectionDatas {
    if (!_arrayCollectionDatas) {
        _arrayCollectionDatas = [NSMutableArray arrayWithCapacity:3];
    }
    return _arrayCollectionDatas;
}

@end
