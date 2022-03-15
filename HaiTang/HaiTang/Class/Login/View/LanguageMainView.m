//
//  LanguageMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/26.
//  Copyright © 2020 zy. All rights reserved.
//

#import "LanguageMainView.h"
#import "BaseTableViewCell.h"

@interface LanguageMainView ()

@property (nonatomic, copy) NSArray<NSString *> *arrayLanguages;

@end

@implementation LanguageMainView
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
}

- (void)updateView {
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayLanguages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = kRGB(16, 16, 16);
    cell.textLabel.font = kFont(14);
    if (indexPath.row < [self.arrayLanguages count]) {
        NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:@"kIndexPath"];
        if (row == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = self.arrayLanguages[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.arrayLanguages count]) {
//        if (indexPath.row == 0) {
//            //简体中文
//            [NSBundle setLanguage:Chinese_Simple];
//            [[NSUserDefaults standardUserDefaults] setObject:Chinese_Simple forKey:kCurrentLanguage];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        } else
        if (indexPath.row == 0) {
            //繁体中文
            [NSBundle setLanguage:Chinese_Traditional];
            [[NSUserDefaults standardUserDefaults] setObject:Chinese_Traditional forKey:kCurrentLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else if (indexPath.row == 1) {
            //英语
            [NSBundle setLanguage:English];
            [[NSUserDefaults standardUserDefaults] setObject:English forKey:kCurrentLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else if (indexPath.row == 2) {
            //日语
            [NSBundle setLanguage:Japanese];
            [[NSUserDefaults standardUserDefaults] setObject:Japanese forKey:kCurrentLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            //韩语
            [NSBundle setLanguage:Korean];
            [[NSUserDefaults standardUserDefaults] setObject:Korean forKey:kCurrentLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"kIndexPath"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectedIndex:)]) {
            [self.delegate performSelector:@selector(tableView:didSelectedIndex:) withObject:tableView withObject:indexPath];
        }
    }
}

#pragma mark - Setter & Getter
- (NSArray<NSString *> *)arrayLanguages {
    if (!_arrayLanguages) {
        _arrayLanguages = @[@"中文繁體", @"English", @"日本语", @"한국어"];
    }
    return _arrayLanguages;
}

@end
