//
//  DepthTableCell.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "DepthTableCell.h"
#import "DepthTableView.h"

#import "TradeListModel.h"
#import "TradeListSubModel.h"

@interface DepthTableCell ()
@property (nonatomic, strong) DepthTableView *sellTableView;
@property (nonatomic, strong) DepthTableView *buyTableView;

@end

@implementation DepthTableCell
#pragma mark - Super Class
- (void)setupSubViews {
    self.backgroundColor = kRGB(3, 14, 30);
    
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(42);
    }];
    
    UILabel *lbBuy = [UILabel labelWithText:NSLocalizedString(@"买", nil) textColor:kRGB(125, 145, 171) font:kFont(12)];
    [topView addSubview:lbBuy];
    [lbBuy makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(16.5);
        make.width.equalTo(35);
    }];
    
    UILabel *lbNumber = [UILabel labelWithText:NSLocalizedString(@"数量", nil) textColor:kRGB(125, 145, 171) font:kFont(12)];
    [topView addSubview:lbNumber];
    [lbNumber makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(lbBuy.mas_right);
    }];
    
    UILabel *lbPrice = [UILabel labelWithText:NSLocalizedString(@"价格(USDT)", nil) textColor:kRGB(125, 145, 171) font:kFont(12)];
    [topView addSubview:lbPrice];
    [lbPrice makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    
    UILabel *lbSell = [UILabel labelWithText:NSLocalizedString(@"卖", nil) textColor:kRGB(125, 145, 171) font:kFont(12)];
    lbSell.textAlignment = NSTextAlignmentRight;
    [topView addSubview:lbSell];
    [lbSell makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(-16.5);
        make.width.equalTo(35);
    }];
    
    UILabel *lbNumber1 = [UILabel labelWithText:NSLocalizedString(@"数量", nil) textColor:kRGB(125, 145, 171) font:kFont(12)];
    [topView addSubview:lbNumber1];
    [lbNumber1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(lbSell.mas_left);
    }];
    
    [self addSubview:self.buyTableView];
    [self.buyTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(0);
        make.width.equalTo(kScreenWidth / 2);
        make.bottom.equalTo(0);
    }];
    
    [self addSubview:self.sellTableView];
    [self.sellTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyTableView);
        make.right.equalTo(0);
        make.width.equalTo(self.buyTableView);
        make.bottom.equalTo(0);
    }];
}

- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[TradeListModel class]]) {
        TradeListModel *listModel = model;
        NSMutableArray *asksArr = [[NSMutableArray alloc] initWithArray:listModel.asks];
        NSMutableArray *bidsArr = [[NSMutableArray alloc] initWithArray:listModel.bids];
        NSMutableArray *sellArray = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray *buyArray = [NSMutableArray arrayWithCapacity:20];
        //卖(从低到高)
        CGFloat asksArrMax = 0;
        CGFloat asksArrMinx = [asksArr[0][0] floatValue];
        for (NSArray *arr in asksArr) {
            if (asksArrMax < [arr[0] floatValue]) {
                asksArrMax = [arr[0] floatValue];
            }
            if (asksArrMinx > [arr[0] floatValue]) {
                asksArrMinx = [arr[0] floatValue];
            }
        }
        
        NSInteger askCount = [asksArr count];
        if (askCount > 20) {
            askCount = 20;
        }
        
        for (int i = 0; i < askCount; i++) {
            NSArray *minArr = asksArr[i];
            for (int j = i + 1; j < asksArr.count; j ++) {
                NSArray *ar2 = asksArr[j];
                if ([minArr[0] floatValue] > [ar2[0] floatValue]) {
                    [asksArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                    minArr = ar2;
                }
             }
            TradeListSubModel *model = [[TradeListSubModel alloc] init];
            model.price = [NSString stringWithFormat:@"%@", minArr[0]];
            model.number = [NSString stringWithFormat:@"%@",minArr[1]];
            model.max = asksArrMax;
            model.min = asksArrMinx;
            model.index = i + 1;
            [sellArray addObject:model];
        }
        //买(从高到低)
        CGFloat bidsArrMax = 0;
        CGFloat bidsArrMinx = [asksArr[0][0] floatValue];;
        for (NSArray *arr in bidsArr) {
            if (bidsArrMax < [arr[0] floatValue]) {
                bidsArrMax = [arr[0] floatValue];
            }
            if (bidsArrMinx > [arr[0] floatValue]) {
                bidsArrMinx = [arr[0] floatValue];
            }
        }
        
        NSInteger bidCount = [bidsArr count];
        if (bidCount > 20) {
            bidCount = 20;
        }
        
        for (int i = 0; i < bidCount; i++) {
            NSArray *maxArr = bidsArr[i];
            for (int j = i + 1; j < bidsArr.count; j ++) {
                NSArray *ar2 = bidsArr[j];
                if ([maxArr[0] floatValue] < [ar2[0] floatValue]) {
                    [bidsArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                    maxArr = ar2;
                }
             }
            TradeListSubModel *model = [[TradeListSubModel alloc] init];
            model.price = [NSString stringWithFormat:@"%@",maxArr[0]];
            model.number = [NSString stringWithFormat:@"%@",maxArr[1]];
            model.max = bidsArrMax;
            model.min = bidsArrMinx;
            model.index = i + 1;
            [buyArray addObject:model];
        }
        
        self.buyTableView.arrayTableDatas = buyArray;
        self.sellTableView.arrayTableDatas = sellArray;
    }
}

#pragma mark - Setter & Getter
- (DepthTableView *)buyTableView {
    if (!_buyTableView) {
        _buyTableView = [[DepthTableView alloc] init];
        _buyTableView.type = @"BUY";
    }
    return _buyTableView;
}

- (DepthTableView *)sellTableView {
    if (!_sellTableView) {
        _sellTableView = [[DepthTableView alloc] init];
        _sellTableView.type = @"SELL";
    }
    return _sellTableView;
}

@end
