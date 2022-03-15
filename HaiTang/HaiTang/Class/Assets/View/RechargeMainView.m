//
//  RechargeMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RechargeMainView.h"
#import "RechargeCollectionCell.h"

#import "AddressModel.h"
#import "AssetsMainViewModel.h"

@interface RechargeMainView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *lbSymbol;
@property (nonatomic, strong) UILabel *lbAddress;             //充币地址
@property (nonatomic, strong) UILabel *lbMemoAddress;         //Memo地址
@property (nonatomic, strong) UILabel *lbNumberTitle;
@property (nonatomic, strong) UIImageView *imgViewQRCode;
@property (nonatomic, strong) UIButton *btnCopyMemoAddress;

@property (nonatomic, strong) UIView *linkView;
@property (nonatomic, strong) UITextField *tfNumber;
@property (nonatomic, strong) UITextField *tfHash;
@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, strong) NSMutableArray *arrayCollectionDatas;

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addressValue;

@end

@implementation RechargeMainView
#pragma mark - Event Response
- (void)onBtnWithSelectSymbolEvent:(UIButton *)btn {
    //选择币种
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewWithSelectSymbol:)]) {
        [self.delegate performSelector:@selector(mainViewWithSelectSymbol:) withObject:self.lbSymbol.text];
    }
}

- (void)onBtnWithSaveQRCodeEvent:(UIButton *)btn {
    //保存二维码
    UIImageWriteToSavedPhotosAlbum(self.imgViewQRCode.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [JYToastUtils showWithStatus:NSLocalizedString(@"保存成功", nil) duration:2];
    } else {
        [JYToastUtils showWithStatus:NSLocalizedString(@"保存失败", nil) duration:2];
    }
}

- (void)onBtnWithCopyAddressEvent:(UIButton *)btn {
    //复制地址
    UIPasteboard *myPasteboard = [UIPasteboard generalPasteboard];
    myPasteboard.string = self.address;
    [JYToastUtils showLongWithStatus:NSLocalizedString(@"复制成功", nil) completionHandle:nil];
}

- (void)onBtnWithCopyOtherAddressEvent:(UIButton *)btn {
    //复制Memo、Tag
    UIPasteboard *myPasteboard = [UIPasteboard generalPasteboard];
    myPasteboard.string = self.addressValue;
    [JYToastUtils showLongWithStatus:NSLocalizedString(@"复制成功", nil) completionHandle:nil];
}

- (void)onBtnExchangeLinkEvent:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = YES;
            obj.backgroundColor = kRGB(0, 102, 237);
        } else {
            obj.selected = NO;
            obj.backgroundColor = [UIColor clearColor];
        }
    }];
    NSString *link = self.arrayBtnTitles[index];
    NSString *symbol = [NSString stringWithFormat:@"USDT-%@", link];
    [(AssetsMainViewModel *)self.mainViewModel setSymbol:symbol];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithRechargeAddress)]) {
        [self.delegate performSelector:@selector(viewWithRechargeAddress)];
    }
}

- (void)onBtnSubmitEvent:(UIButton *)btn {
    if ([NSString isEmpty:self.tfNumber.text] ||
         [self.tfNumber.text integerValue] <= 0.00) {
        [JYToastUtils showWithStatus:@"请输入充币数量" duration:2];
        return;
    }
    if ([NSString isEmpty:[(AssetsMainViewModel *)self.mainViewModel remark]]) {
        [JYToastUtils showWithStatus:@"请上传充币凭证" duration:2];
        return;
    }
    NSString *dealId = [NSString isEmpty:self.tfHash.text] ? @"" : self.tfHash.text;
    [(AssetsMainViewModel *)self.mainViewModel setPrice:self.tfNumber.text];
    [(AssetsMainViewModel *)self.mainViewModel setToAddress:dealId];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithSubmitRecharge)]) {
        [self.delegate performSelector:@selector(viewWithSubmitRecharge)];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight)];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(kScreenWidth, 990.5);
    if (@available(iOS 11.0, *)) {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:mainScrollView];
    
    UIView *contentView = [[UIView alloc] init];
    [mainScrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(mainScrollView);
        make.height.equalTo(990.5);
    }];
    
    self.lbSymbol = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
    [contentView addSubview:self.lbSymbol];
    [self.lbSymbol makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
    }];
    
    UIButton *btnSelectCoin = [UIButton buttonWithTitle:NSLocalizedString(@"选择币种", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithSelectSymbolEvent:)];
    [btnSelectCoin setImage:[UIImage imageNamed:@"xianyou"] forState:UIControlStateNormal];
    CGFloat btnW = [btnSelectCoin.titleLabel.text widthForFont:kFont(12) maxHeight:30] + 20;
    [contentView addSubview:btnSelectCoin];
    [btnSelectCoin makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(self.lbSymbol);
        make.width.equalTo(btnW);
        make.height.equalTo(30);
    }];
    [btnSelectCoin setTitleLeftSpace:10];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kRGB(236, 236, 236);
    [contentView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(0.5);
        make.top.equalTo(btnSelectCoin.mas_bottom);
    }];
    
    [contentView addSubview:self.linkView];
    [self.linkView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(0);
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(74);
    }];
    
    self.imgViewQRCode = [[UIImageView alloc] init];
    [contentView addSubview:self.imgViewQRCode];
    [self.imgViewQRCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(164);
        make.width.height.equalTo(100);
        make.centerX.equalTo(0);
    }];
    
    UIButton *btnSave = [UIButton buttonWithTitle:NSLocalizedString(@"保存二维码", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithSaveQRCodeEvent:)];
    btnSave.layer.cornerRadius = 2;
    btnSave.layer.borderColor = kRGB(0, 102, 237).CGColor;
    btnSave.layer.borderWidth = 1;
    [contentView addSubview:btnSave];
    [btnSave makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewQRCode.mas_bottom).offset(15);
        make.centerX.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(24);
    }];
    
    self.lbAddress = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
    self.lbAddress.numberOfLines = 0;
    //设置行间距
    [self.lbAddress setParagraphSpacing:0 lineSpacing:10];
    self.lbAddress.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:self.lbAddress];
    [self.lbAddress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnSave.mas_bottom).offset(40);
        make.centerX.equalTo(0);
        make.left.equalTo(53);
        make.right.equalTo(-53);
    }];
    
    UIButton *btnCopyAddress = [UIButton buttonWithTitle:NSLocalizedString(@"复制地址", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithCopyAddressEvent:)];
    btnCopyAddress.layer.cornerRadius = 2;
    btnCopyAddress.layer.borderColor = kRGB(0, 102, 237).CGColor;
    btnCopyAddress.layer.borderWidth = 1;
    [contentView addSubview:btnCopyAddress];
    [btnCopyAddress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbAddress.mas_bottom).offset(15);
        make.centerX.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(24);
    }];
    
    self.lbMemoAddress = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:kFont(14)];
    self.lbMemoAddress.numberOfLines = 0;
    self.lbMemoAddress.textAlignment = NSTextAlignmentCenter;
    self.lbMemoAddress.hidden = YES;
    //设置行间距
    [self.lbMemoAddress setParagraphSpacing:0 lineSpacing:10];
    [contentView addSubview:self.lbMemoAddress];
    [self.lbMemoAddress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnCopyAddress.mas_bottom).offset(30);
        make.centerX.equalTo(0);
        make.left.equalTo(53);
        make.right.equalTo(-53);
    }];
    
    self.btnCopyMemoAddress = [UIButton buttonWithTitle:NSLocalizedString(@"复制", nil) titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnWithCopyOtherAddressEvent:)];
    self.btnCopyMemoAddress.layer.cornerRadius = 2;
    self.btnCopyMemoAddress.layer.borderColor = kRGB(0, 102, 237).CGColor;
    self.btnCopyMemoAddress.layer.borderWidth = 1;
    self.btnCopyMemoAddress.hidden = YES;
    [contentView addSubview:self.btnCopyMemoAddress];
    [self.btnCopyMemoAddress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbMemoAddress.mas_bottom).offset(15);
        make.centerX.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(24);
    }];
    
    self.lbNumberTitle = [UILabel labelWithText:NSLocalizedString(@"充币数量", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [contentView addSubview:self.lbNumberTitle];
    [self.lbNumberTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbAddress.mas_bottom).offset(69);
        make.left.equalTo(15);
    }];
    
    self.tfNumber = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入充币数量", nil) hasLine:YES];
    self.tfNumber.keyboardType = UIKeyboardTypeDecimalPad;
    [contentView addSubview:self.tfNumber];
    [self.tfNumber makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbNumberTitle.mas_bottom);
        make.left.equalTo(15);
        make.width.equalTo(kScreenWidth - 30);
        make.height.equalTo(40);
    }];
    
    UILabel *lbHashTitle = [UILabel labelWithText:NSLocalizedString(@"区块链交易ID(选填)", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [contentView addSubview:lbHashTitle];
    [lbHashTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfNumber.mas_bottom).offset(20);
        make.left.equalTo(self.lbNumberTitle);
    }];
    
    self.tfHash = [[UITextField alloc] initNoLeftViewWithPlaceHolder:NSLocalizedString(@"请输入充币交易hash值", nil) hasLine:YES];
    self.tfHash.keyboardType = UIKeyboardTypeAlphabet;
    [contentView addSubview:self.tfHash];
    [self.tfHash makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbHashTitle.mas_bottom);
        make.left.width.height.equalTo(self.tfNumber);
    }];
    
    UILabel *lbCollectionTitle = [UILabel labelWithText:NSLocalizedString(@"请上传充币凭证", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
    [contentView addSubview:lbCollectionTitle];
    [lbCollectionTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tfHash.mas_bottom).offset(20);
        make.left.equalTo(lbHashTitle);
    }];
    
    [contentView addSubview:self.mainCollectionView];
    [self.mainCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbCollectionTitle.mas_bottom).offset(10);
        make.left.right.equalTo(0);
        make.height.equalTo(110);
    }];
    
    UIButton *btnSubmit = [UIButton buttonWithTitle:NSLocalizedString(@"提交", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnSubmitEvent:)];
    btnSubmit.layer.cornerRadius = 4;
    btnSubmit.backgroundColor = kRGB(0, 102, 237);
    [contentView addSubview:btnSubmit];
    [btnSubmit makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(28);
        make.top.equalTo(self.mainCollectionView.mas_bottom).offset(20);
    }];
}

- (void)updateView {
    [self.arrayCollectionDatas removeAllObjects];
    [self.arrayCollectionDatas addObject:kCameraImageName];
    [self.mainCollectionView reloadData];
    
    AddressModel *addressModel = [(AssetsMainViewModel *)self.mainViewModel rechargeAddressModel];
    self.symbol = addressModel.symbol;
    self.address = addressModel.address;
    self.addressValue = addressModel.memoTagValue;
    self.lbSymbol.text = [addressModel.symbol containsString:@"USDT"] ? [self.symbol substringToIndex:4] : self.symbol;
    
    if ([self.symbol containsString:@"USDT"]) {
        self.linkView.hidden = NO;
        [self.imgViewQRCode updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(164);
        }];
    } else {
        self.linkView.hidden = YES;
        [self.imgViewQRCode updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(90);
        }];
    }
    //链接生成二维码
    //1.创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.回复默认设置
    [filter setDefaults];
    //4.将链接字符串转Data格式
    NSData *stringData = [addressModel.address dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:stringData forKey:@"inputMessage"];
    //5.生成二维码
    CIImage *qrcodeImage = [filter outputImage];
    self.imgViewQRCode.image = [qrcodeImage createNonInterpolatedWithSize:100];
    
    self.lbAddress.text = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"充币地址", nil), addressModel.address];
    
    self.lbMemoAddress.hidden = YES;
    self.btnCopyMemoAddress.hidden = YES;
    
    [self.lbNumberTitle updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbAddress.mas_bottom).offset(69);
    }];
    
    if ([addressModel.symbol isEqualToString:@"EOS"]) {
        self.lbMemoAddress.hidden = NO;
        self.btnCopyMemoAddress.hidden = NO;
        self.lbMemoAddress.text = [NSString stringWithFormat:@"Memo：%@", addressModel.memoTagValue];
        [self.lbNumberTitle updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lbAddress.mas_bottom).offset(141);
        }];
    }
}

- (void)updateLinkBtnView {
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.selected = YES;
            obj.backgroundColor = kRGB(0, 102, 237);
        } else {
            obj.selected = NO;
            obj.backgroundColor = [UIColor clearColor];
        }
    }];
}

- (void)updateImages {
    //更新选中的图片
    NSArray *images = [[(AssetsMainViewModel *)self.mainViewModel arrayImageDatas] mutableCopy];
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCollectionDatas removeLastObject];
        if (![self.arrayCollectionDatas containsObject:obj]) {
            [self.arrayCollectionDatas addObject:obj];
        }

        if (self.arrayCollectionDatas.count < 3) {
            [self.arrayCollectionDatas addObject:kCameraImageName];
        }
    }];
    [self.mainCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.arrayCollectionDatas) {
        return [self.arrayCollectionDatas count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RechargeCollectionCell *cell = [RechargeCollectionCell cellWithNibCollectionView:collectionView withIndexPath:indexPath];
    if (indexPath.item < [self.arrayCollectionDatas count]) {
        WeakSelf
        [cell setOnDeleteBlock:^{
            //清除照片
            [weakSelf.arrayCollectionDatas removeObjectAtIndex:indexPath.item];
            if (![weakSelf.arrayCollectionDatas containsObject:kCameraImageName]) {
                [weakSelf.arrayCollectionDatas addObject:kCameraImageName];
            }
            [collectionView reloadData];
        }];
        [cell setViewWithModel:self.arrayCollectionDatas[indexPath.item]];
        
        NSMutableArray *arrayUrls = [NSMutableArray arrayWithArray:self.arrayCollectionDatas];
        if ([arrayUrls containsObject:kCameraImageName]) {
            [arrayUrls removeObject:kCameraImageName];
        }
        NSString *remark = [arrayUrls componentsJoinedByString:@","];
        [(AssetsMainViewModel *)self.mainViewModel setRemark:remark];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 50) / 3, 90);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item < [self.arrayCollectionDatas count]) {
        NSString *imageName = self.arrayCollectionDatas[indexPath.item];
        if ([imageName isEqualToString:kCameraImageName]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithSelectImages)]) {
                [self.delegate performSelector:@selector(viewWithSelectImages)];
            }
        }
    }
}

#pragma mark - Setter & Getter
- (NSArray<NSString *> *)arrayBtnTitles {
    if (!_arrayBtnTitles) {
        _arrayBtnTitles = @[@"ERC20", @"TRC20", @"OMNI"];
    }
    return _arrayBtnTitles;
}

- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:3];
    }
    return _arrayBtns;
}

- (UIView *)linkView {
    if (!_linkView) {
        _linkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 74)];
        
        UILabel *lbTitle = [UILabel labelWithText:NSLocalizedString(@"链名称", nil) textColor:kRGB(16, 16, 16) font:kFont(14)];
        [_linkView addSubview:lbTitle];
        [lbTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.equalTo(15);
        }];
        
        if (self.arrayBtns) {
            [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self.arrayBtns removeAllObjects];
        }
        [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithTitle:obj titleColor:kRGB(0, 102, 237) highlightedTitleColor:kRGB(0, 102, 237) font:kFont(12) target:self selector:@selector(onBtnExchangeLinkEvent:)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.layer.cornerRadius = 2;
            btn.layer.borderColor = kRGB(0, 102, 237).CGColor;
            btn.layer.borderWidth = 1;
            btn.tag = idx + 1000;
            [_linkView addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lbTitle.mas_bottom).offset(10);
                make.left.equalTo(15 + 75 * idx + 15 * idx);
                make.width.equalTo(75);
                make.height.equalTo(24);
            }];
            [self.arrayBtns addObject:btn];
            if (idx == 0) {
                btn.selected = YES;
                btn.backgroundColor = kRGB(0, 102, 237);
            }
        }];
    }
    return _linkView;
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 10;
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110) collectionViewLayout:flowLayout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RechargeCollectionCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([RechargeCollectionCell class])];
    }
    return _mainCollectionView;
}

- (NSMutableArray *)arrayCollectionDatas {
    if (!_arrayCollectionDatas) {
        _arrayCollectionDatas = [NSMutableArray arrayWithCapacity:3];
    }
    return _arrayCollectionDatas;
}

@end
