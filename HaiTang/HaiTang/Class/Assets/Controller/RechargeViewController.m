//
//  RechargeViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "RechargeViewController.h"
#import "RecordsViewController.h"
#import "SelectSymbolViewController.h"

#import "RechargeMainView.h"

#import "SymbolModel.h"
#import "AssetsMainViewModel.h"

#import "TZImagePickerController.h"

@interface RechargeViewController ()<RechargeMainViewDelegate, TZImagePickerControllerDelegate>
@property (nonatomic, strong) RechargeMainView *mainView;
@property (nonatomic, strong) AssetsMainViewModel *mainViewModel;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainViewModel.type = @"CHANGER";
    [self fetchSymbolListData];
    //系统不会自动调整滚动视图的插入，不会默认下调20px
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Request Data
- (void)fetchSymbolListData {
    //币种列表
    [self.mainViewModel fetchSymbolListWithResult:^(BOOL success) {
        if (success) {
            SymbolModel *symbolModel = self.mainViewModel.arraySymbolDatas.firstObject;
            self.mainViewModel.symbol = [symbolModel.symbols containsString:@"USDT"] ? @"USDT-ERC20" : symbolModel.symbols;
            [self fetchRechargeAddressData];
        }
    }];
}

- (void)fetchRechargeAddressData {
    [self.mainViewModel fetchRechargeAddressWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

- (void)fetchSubmitRecharge {
    [self.mainViewModel fetchSubmitRechargeWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"提交成功", nil) completionHandle:^{
                [self popViewController];
            }];
        }
    }];
}

#pragma mark - RechargeMainViewDelegate
- (void)mainViewWithSelectSymbol:(NSString *)symbol {
    //选择币种
    SelectSymbolViewController *selectSymbolVC = [[SelectSymbolViewController alloc] init];
    selectSymbolVC.symbol = symbol;
    selectSymbolVC.type = @"CHANGER";
    WeakSelf
    [selectSymbolVC setOnSelectedSymbolBlock:^(NSString * _Nonnull symbol) {
        //选择币种
        weakSelf.mainViewModel.symbol = [symbol containsString:@"USDT"] ? @"USDT-ERC20" : symbol;
        [weakSelf fetchRechargeAddressData];
        [weakSelf.mainView updateLinkBtnView];
    }];
    [self.navigationController pushViewController:selectSymbolVC animated:YES];
}

- (void)viewWithRechargeAddress {
    [self fetchRechargeAddressData];
}

- (void)viewWithSelectImages {
    //选择照片
    TZImagePickerController *imagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:0 delegate:self pushPhotoPickerVc:YES];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)viewWithSubmitRecharge {
    [self fetchSubmitRecharge];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.mainViewModel uploadPhotoFilesWith:photos withResult:^(BOOL success) {
        if (success) {
            [self.mainView updateImages];
        }
    }];
}

#pragma mark - Event Response
- (void)onBtnWithCheckRechargeRecordsEvent:(UIButton *)btn {
    //充币记录
    RecordsViewController *recordsVC = [[RecordsViewController alloc] init];
    recordsVC.recordType = RecordTypeRecharge;
    recordsVC.symbols = @"";
    [self.navigationController pushViewController:recordsVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"钱包充币", nil);
    UIButton *btnRecord = [UIButton buttonWithImageName:@"ctb-jl" highlightedImageName:@"ctb-jl" target:self selector:@selector(onBtnWithCheckRechargeRecordsEvent:)];
    self.navBar.navRightView = btnRecord;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (RechargeMainView *)mainView {
    if (!_mainView) {
        _mainView = [[RechargeMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (AssetsMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[AssetsMainViewModel alloc] initWithSymbol:self.symbol];
    }
    return _mainViewModel;
}

@end
