//
//  FiatOrderListViewController.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/12.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatOrderListViewController.h"
#import "FiatOrderViewController.h"

@interface FiatOrderListViewController ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *arrayBtns;
@property (nonatomic, copy) NSArray<NSString *> *arrayBtnTitles;
@property (nonatomic, strong) NSArray *arrayIndicatorDatas;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) NSInteger btnIndex;
@end

@implementation FiatOrderListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selectIndex = 0;
    self.arrayIndicatorDatas = @[ @"已完成", @"待付款", @"已付款", @"已取消", @"申诉中"];
    [self reloadData];
}

#pragma mark - Event Response
- (void)onBtnSwitchEvent:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    NSInteger index = btn.tag - 1000;
    self.btnIndex = index;
    WeakSelf
    [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = YES;
            obj.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.lineView.centerX = obj.centerX;
            }];
        } else {
            obj.selected = NO;
            obj.titleLabel.font = kFont(18);
        }
    }];
    if (index == 0) {
        self.arrayIndicatorDatas = @[NSLocalizedString(@"已完成", nil), NSLocalizedString(@"待付款", nil), NSLocalizedString(@"已付款", nil), NSLocalizedString(@"已取消", nil), NSLocalizedString(@"申诉中", nil)];
    } else {
        self.arrayIndicatorDatas = @[NSLocalizedString(@"已完成", nil), NSLocalizedString(@"待收款", nil), NSLocalizedString(@"待放币", nil), NSLocalizedString(@"已取消", nil), NSLocalizedString(@"申诉中", nil)];
    }
    
    self.selectIndex = 0;
    
    [self reloadData];
}

#pragma mark - WMPageController DataSource
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, kNavBarHeight, self.view.frame.size.width, 47);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return [self.arrayIndicatorDatas count];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    FiatOrderViewController *orderVC = [[FiatOrderViewController alloc] init];
    orderVC.orderType = self.btnIndex;
    if (index == 0) {
        //已完成
        orderVC.orderStatus = FiatOrderStatusFinish;
    } else if (index == 1) {
        if (self.btnIndex == 0) {
            //待付款
            orderVC.orderStatus = FiatOrderStatusWaitPayment;
        } else {
            //待收款
            orderVC.orderStatus = FiatOrderStatusPendingPayment;
        }
    } else if (index == 2) {
        if (self.btnIndex == 0) {
            //已付款
            orderVC.orderStatus = FiatOrderStatusPaid;
        } else {
            //待放币
            orderVC.orderStatus = FiatOrderStatusWaitPutMoney;
        }
    } else if (index == 3) {
        //已取消
        orderVC.orderStatus = FiatOrderStatusCancelled;
    } else {
        //申诉中
        orderVC.orderStatus = FiatOrderStatusAppealing;
    }
    return orderVC;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.arrayIndicatorDatas[index];
}

#pragma mark - Super Class
- (void)setupNavigation {
    UIView *titleView = [[UIView alloc] init];
    [titleView addSubview:self.lineView];
    if (self.arrayBtns) {
        [self.arrayBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.arrayBtns removeAllObjects];
    }
    CGFloat rowSpace = (kScreenWidth - 425) / 2;
    [self.arrayBtnTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithTitle:obj titleColor:kRGB(16, 16, 16) highlightedTitleColor:kRGB(16, 16, 16) font:kFont(18) target:self selector:@selector(onBtnSwitchEvent:)];
        btn.tag = idx + 1000;
        [btn setTitleColor:kRGB(16, 16, 16) forState:UIControlStateSelected];
        [titleView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rowSpace + 90 * idx + 45 * idx);
            make.top.equalTo(10);
            make.width.equalTo(90);
            make.height.equalTo(30);
        }];
        [self.arrayBtns addObject:btn];
        if (idx == 0) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
            self.lineView.x = rowSpace + 32.5;
        }
    }];
    self.navBar.titleView = titleView;
    self.btnIndex = 0;
}

- (void)setupSubViews {
    self.menuBGColor = [UIColor whiteColor];
    self.menuItemWidth = kScreenWidth / [self.arrayIndicatorDatas count];
    self.progressColor = [UIColor clearColor];
    [self.menuView reload];
}

#pragma mark - Setter And Getter
- (NSArray *)arrayIndicatorDatas {
    if (!_arrayIndicatorDatas) {
        _arrayIndicatorDatas = @[@"已完成", @"待付款", @"已付款", @"已取消", @"申诉中"];
    }
    return _arrayIndicatorDatas;
}

- (NSArray<NSString *> *)arrayBtnTitles {
    if (!_arrayBtnTitles) {
        _arrayBtnTitles = @[NSLocalizedString(@"购买订单", nil), NSLocalizedString(@"出售订单", nil)];
    }
    return _arrayBtnTitles;
}

- (NSMutableArray<UIButton *> *)arrayBtns {
    if (!_arrayBtns) {
        _arrayBtns = [NSMutableArray arrayWithCapacity:2];
    }
    return _arrayBtns;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 25, 2)];
        _lineView.backgroundColor = kRGB(0, 102, 237);
    }
    return _lineView;
}

@end
