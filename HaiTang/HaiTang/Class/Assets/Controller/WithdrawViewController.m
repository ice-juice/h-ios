//
//  WithdrawViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "WithdrawViewController.h"
#import "RecordsViewController.h"
#import "HBK_ScanViewController.h"
#import "SelectSymbolViewController.h"
#import "ModifyPasswordViewController.h"
#import "SecuritySettingsViewController.h"

#import "WithdrawMainView.h"

#import "SymbolModel.h"
#import "AssetsMainViewModel.h"

@interface WithdrawViewController ()<WithdrawMainViewDelegate>
@property (nonatomic, strong) WithdrawMainView *mainView;
@property (nonatomic, strong) AssetsMainViewModel *mainViewModel;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainViewModel.type = @"WITHDRAW";
    [self fetchSymbolListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchUserInfoData];
}

#pragma mark - Request Data
- (void)fetchSymbolListData {
    //币种列表
    [self.mainViewModel fetchSymbolListWithResult:^(BOOL success) {
        if (success) {
            SymbolModel *symbolModel = self.mainViewModel.arraySymbolDatas[0];
            self.mainViewModel.symbol = symbolModel.symbols;
            [self fetchWithdrawInfoData];
        }
    }];
}

- (void)fetchWithdrawInfoData {
    [self.mainViewModel fetchWithdrawInfoWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

- (void)fetchUserInfoData {
    [self.mainViewModel fetchUserInfoDataWithResult:^(BOOL success) {
        if (success) {
            [self.mainView updateView];
        }
    }];
}

#pragma mark - WithdrawMainViewDelegate
- (void)mainViewWithSelectSymbol {
    //选择币种
    SelectSymbolViewController *selectSymbolVC = [[SelectSymbolViewController alloc] init];
    selectSymbolVC.symbol = self.mainViewModel.symbol;
    selectSymbolVC.type = @"WITHDRAW";
    WeakSelf
    [selectSymbolVC setOnSelectedSymbolBlock:^(NSString * _Nonnull symbol) {
        //选择币种
        weakSelf.mainViewModel.symbol = symbol;
        [weakSelf fetchWithdrawInfoData];
    }];
    [self.navigationController pushViewController:selectSymbolVC animated:YES];
}

- (void)mainViewWithSendVerifyCode {
    //获取验证码
    [self.mainViewModel sendVerifyCodeCountDown:^(NSString * _Nonnull countDown, BOOL isEnd) {
        [self.mainView updateCountDown:countDown isEnd:isEnd];
    } result:^(BOOL success) {
        if (success) {
            [JYToastUtils showWithStatus:NSLocalizedString(@"发送验证码成功", nil) duration:2];
        } else {
            [self.mainView updateCountDown:NSLocalizedString(@"重新发送", nil) isEnd:YES];
        }
    }];
}

- (void)forgetAssetsPassword {
    //资产密码
    ModifyPasswordViewController *modifyPasswordVC = [[ModifyPasswordViewController alloc] init];
    modifyPasswordVC.modifyType = ModifyTypeAssetsPassword;
    [self.navigationController pushViewController:modifyPasswordVC animated:YES];
}

- (void)goSafety {
    //安全设置
    SecuritySettingsViewController *securityVC = [[SecuritySettingsViewController alloc] init];
    [self.navigationController pushViewController:securityVC animated:YES];
}

- (void)scanAddress {
    //扫一扫
    HBK_ScanViewController *scanVC = [[HBK_ScanViewController alloc] init];
    WeakSelf
    scanVC.SSBlock = ^(NSString *str) {
        StrongSelf
        strongSelf.mainViewModel.toAddress = str;
        strongSelf.mainView.tfAddress.text = str;
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}

#pragma mark - Event Response
- (void)onBtnWithCheckWithdrawRecordsEvent:(UIButton *)btn {
    //提币记录
    RecordsViewController *recordsVC = [[RecordsViewController alloc] init];
    recordsVC.recordType = RecordTypeWithdraw;
    recordsVC.symbols = @"";
    [self.navigationController pushViewController:recordsVC animated:YES];
}

- (void)mainViewWithSubmitWithdraw {
    //提币
    WeakSelf
    [self.mainViewModel fetchSubmitWithdrawWithResult:^(BOOL success) {
        if (success) {
            [JYToastUtils showLongWithStatus:NSLocalizedString(@"请求成功", nil) completionHandle:^{
                RecordsViewController *recordsVC = [[RecordsViewController alloc] init];
                recordsVC.recordType = RecordTypeWithdraw;
                recordsVC.symbols = @"";
                [weakSelf.navigationController pushViewController:recordsVC animated:YES];
            }];
        }
    }];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"钱包提币", nil);
    
    UIButton *btnRecord = [UIButton buttonWithImageName:@"ctb-jl" highlightedImageName:@"ctb-jl" target:self selector:@selector(onBtnWithCheckWithdrawRecordsEvent:)];
    self.navBar.navRightView = btnRecord;
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (WithdrawMainView *)mainView {
    if (!_mainView) {
        _mainView = [[WithdrawMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
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
