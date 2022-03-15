//
//  CollectionSettingsMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CollectionSettingsMainView.h"
#import "CollectionSettingsTableCell.h"
#import "MarginPopupView.h"

#import "NewModel.h"
#import "UserInfoManager.h"
#import "HomeMainViewModel.h"

@interface CollectionSettingsMainView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *emptyDataView;

@end

@implementation CollectionSettingsMainView
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[(HomeMainViewModel *)self.mainViewModel arrayCollectionDatas] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionSettingsTableCell *cell = [CollectionSettingsTableCell cellWithTableNibView:tableView];
    if (indexPath.section < [[(HomeMainViewModel *)self.mainViewModel arrayCollectionDatas] count]) {
        NewModel *newModel = [(HomeMainViewModel *)self.mainViewModel arrayCollectionDatas][indexPath.section];
        [cell setViewWithModel:newModel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

//编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//点击删除的代理方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
          [self setupSlideBtnWithEditingIndexPath:indexPath];
      });
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //title不设为nil 而是空字符串 理由为啥 ？   自己实践 跑到ios11以下的机器上就知道为啥了
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"哈哈哈哈");
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
    }];
    return @[deleteAction];
}

- (void)setupSlideBtnWithEditingIndexPath:(NSIndexPath *)editingIndexPath {
    // 判断系统是否是 iOS13 及以上版本
    if (@available(iOS 13.0, *)) {
        for (UIView *subView in self.tableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")] && [subView.subviews count] >= 1) {
                // 修改图片
                UIView *remarkContentView = subView.subviews.firstObject;
                [self setupRowActionView:remarkContentView withIndexPath:editingIndexPath];
            }
        }
        return;
    }
    
    // 判断系统是否是 iOS11 及以上版本
    if (@available(iOS 11.0, *)) {
        for (UIView *subView in self.tableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subView.subviews count] >= 1) {
                // 修改图片
                UIView *remarkContentView = subView;
                [self setupRowActionView:remarkContentView withIndexPath:editingIndexPath];
            }
        }
        return;
    }
    
    // iOS11 以下的版本
    CollectionSettingsTableCell *cell = [self.tableView cellForRowAtIndexPath:editingIndexPath];
    for (UIView *subView in cell.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subView.subviews count] >= 1) {
            // 修改图片
            UIView *remarkContentView = subView;
            [self setupRowActionView:remarkContentView withIndexPath:editingIndexPath];
        }
    }
}

- (void)setupRowActionView:(UIView *)rowActionView  withIndexPath:(NSIndexPath *)indexPath {
    // 切割圆角
//    [rowActionView cl_setCornerAllRadiusWithRadiu:20];
    // 改变父 View 的frame，这句话是因为我在 contentView 里加了另一个 View，为了使划出的按钮能与其达到同一高度
    CGRect frame = rowActionView.frame;
    frame.origin.y += (7);
    frame.size.height -= (13);
    rowActionView.frame = frame;
    rowActionView.backgroundColor = [UIColor clearColor];
    // 拿到按钮,设置
    UIButton *button = rowActionView.subviews.firstObject;
    [button setImage:[UIImage imageNamed:@"otc_receivables_delete_light"]  forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.tag = indexPath.section + 1000;
    [button addTarget:self action:@selector(onBtnDeleteAddressEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onBtnDeleteAddressEvent:(UIButton *)btn {
    //删除地址
    NSInteger index = btn.tag - 1000;
    NewModel *newModel = [(HomeMainViewModel *)self.mainViewModel arrayCollectionDatas][index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:deletePayment:)]) {
        [self.delegate performSelector:@selector(tableView:deletePayment:) withObject:self.tableView withObject:newModel.paymentId];
    }
}

#pragma mark - Event Response
- (void)onBtnWithAddEvent:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewWithAddPayment:)]) {
        [self.delegate performSelector:@selector(tableViewWithAddPayment:) withObject:self.tableView];
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(248, 248, 248);

    self.tableView = [self setupTableViewWithDelegate:self style:UITableViewStyleGrouped shouldRefresh:YES];
    self.tableView.rowHeight = 76;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
    
    [self addSubview:self.emptyDataView];
    [self.emptyDataView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.bottom.equalTo(0);
    }];
}

- (void)updateView {
    self.tableView.hidden = NO;
    self.emptyDataView.hidden = [[(HomeMainViewModel *)self.mainViewModel arrayCollectionDatas] count];
    [self.tableView reloadData];
}

#pragma mark - Setter & Getter
- (UIView *)emptyDataView {
    if (!_emptyDataView) {
        _emptyDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _emptyDataView.hidden = YES;
        
        UIImageView *imgViewEmpty = [[UIImageView alloc] initWithImage:[StatusHelper imageNamed:@"aqsz-k"]];
        [_emptyDataView addSubview:imgViewEmpty];
        [imgViewEmpty makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(40);
            make.centerX.equalTo(0);
            make.width.equalTo(134);
            make.height.equalTo(99);
        }];
        
        UILabel *lbEmptyText = [UILabel labelWithText:NSLocalizedString(@"请务必使用您本人的实名账户", nil) textColor:kRGB(153, 153, 153) font:kFont(12)];
        [_emptyDataView addSubview:lbEmptyText];
        [lbEmptyText makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgViewEmpty.mas_bottom).offset(15);
            make.centerX.equalTo(0);
        }];
        
        UIButton *btnAdd = [UIButton buttonWithTitle:NSLocalizedString(@"添加收款方式", nil) titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(14) target:self selector:@selector(onBtnWithAddEvent:)];
        btnAdd.backgroundColor = kRGB(0, 102, 237);
        btnAdd.layer.cornerRadius = 4;
        [_emptyDataView addSubview:btnAdd];
        [btnAdd makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbEmptyText.mas_bottom).offset(40);
            make.left.equalTo(50);
            make.right.equalTo(-50);
            make.height.equalTo(30);
        }];
    }
    return _emptyDataView;
}


@end
