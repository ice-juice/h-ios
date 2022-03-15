//
//  SelectSymbolMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/23.
//  Copyright © 2020 zy. All rights reserved.
//

#import "SelectSymbolMainView.h"
#import "BaseTableViewCell.h"

#import "SymbolModel.h"
#import "AssetsMainViewModel.h"

@interface SelectSymbolMainView ()

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation SelectSymbolMainView
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(AssetsMainViewModel *)self.mainViewModel arraySymbolDatas] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = kRGB(16, 16, 16);
    cell.textLabel.font = kFont(14);
    if (indexPath.row < [[(AssetsMainViewModel *)self.mainViewModel arraySymbolDatas] count]) {
        SymbolModel *symbolModel = [(AssetsMainViewModel *)self.mainViewModel arraySymbolDatas][indexPath.row];
        cell.textLabel.text = symbolModel.symbols;
        if (indexPath.row == self.selectIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [[(AssetsMainViewModel *)self.mainViewModel arraySymbolDatas] count]) {
        self.selectIndex = indexPath.row;
        SymbolModel *symbolModel = [(AssetsMainViewModel *)self.mainViewModel arraySymbolDatas][indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:selectSymbol:)]) {
            [self.delegate performSelector:@selector(tableView:selectSymbol:) withObject:tableView withObject:symbolModel.symbols];
        }
    }
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.tableView = [self setupTableViewWithDelegate:self];
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(kNavBarHeight);
        } else {
            make.top.equalTo(kNavBar_44);
        }
    }];
    self.selectIndex = -1;
}

- (void)updateView {
    NSString *symbol = [(AssetsMainViewModel *)self.mainViewModel symbol];
    [[(AssetsMainViewModel *)self.mainViewModel arraySymbolDatas] enumerateObjectsUsingBlock:^(SymbolModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([symbol isEqualToString:obj.symbols]) {
            self.selectIndex = idx;
        }
    }];
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

@end
