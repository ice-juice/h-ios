//
//  PaymentMethodViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "AddPaymentViewController.h"

#import "PaymentMethodMainView.h"

#import "PaymentTableModel.h"
#import "HomeMainViewModel.h"

@interface PaymentMethodViewController ()<PaymentMethodMainViewDelegate>
@property (nonatomic, strong) PaymentMethodMainView *mainView;
@property (nonatomic, strong) HomeMainViewModel *mainViewModel;

@end

@implementation PaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainViewModel loadPaymentTableDatas];
    [self.mainView updateView];
}

#pragma mark - PaymentMethodMainViewDelegate
- (void)tableView:(UITableView *)tableView addPayment:(PaymentTableModel *)tableModel {
    //添加收款方式
    AddPaymentViewController *addVC = [[AddPaymentViewController alloc] init];
    addVC.addPaymentType = tableModel.addType;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - Super Class
- (void)setupNavigation {
    self.navBar.title = NSLocalizedString(@"收款方式", nil);
}

- (void)setupSubViews {
    [self.view addSubview:self.mainView];
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (PaymentMethodMainView *)mainView {
    if (!_mainView) {
        _mainView = [[PaymentMethodMainView alloc] initWithDelegate:self viewModel:self.mainViewModel];
    }
    return _mainView;
}

- (HomeMainViewModel *)mainViewModel {
    if (!_mainViewModel) {
        _mainViewModel = [[HomeMainViewModel alloc] init];
    }
    return _mainViewModel;
}

@end
