//
//  KLineMainViewModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/3.
//  Copyright © 2020 zy. All rights reserved.
//

#import "KLineMainViewModel.h"
#import "Service.h"
#import "QuotesModel.h"
#import "TradeListModel.h"
#import "TradeListSubModel.h"

@implementation KLineMainViewModel
#pragma mark - Life Cycle
- (instancetype)initWithSymbol:(NSString *)symbol {
    self = [super init];
    if (self) {
        _symbol = symbol;
    }
    return self;
}

- (instancetype)initWithSymbol:(NSString *)symbol type:(NSString *)type {
    self = [super init];
    if (self) {
        _symbol = symbol;
        _type = type;
    }
    return self;
}

#pragma mark - Http Request
- (void)fetchSymbolQuotesWithResult:(RequestResult)result {
    //币种行情
    NSDictionary *params0 = @{@"type" : self.type};
    [Service fetchCurrencyQuotesWithParams:params0 mapper:[QuotesModel class] showHUD:NO success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.arrayQuotesDatas = responseModel.data;
            [self.arrayQuotesDatas enumerateObjectsUsingBlock:^(QuotesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.symbol isEqual:self.symbol]) {
                    self.currentQuotesModel = obj;
                    *stop = YES;
                }
            }];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取币种行情失败");
        result(NO);
    }];
}

- (void)fetchContractIntroductionWithResult:(RequestResult)result {
    NSDictionary *params = @{@"symbol" : self.symbol};
    [Service fetchContractIntroductionWithParams:params mapper:[TradeListSubModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.introductionModel = responseModel.data;
            self.introductionModel.symbol = self.symbol;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取合约简介失败");
        result(NO);
    }];
}

- (void)fetchCurrencyDealInfoWithResult:(RequestResult)result {
    //币种交易信息（深度）
    NSDictionary *params2 = @{@"symbol" : self.symbol,
                              @"type" : self.type
    };
    [Service fetchCurrencyDealInfoWithParams:params2 mapper:[TradeListModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if ([NSObject isEmptyWithObject:responseModel.data]) {
                self.tradeListModel = responseModel.data;
            }
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取币币交易信息（深度）失败");
        result(NO);
    }];
}

- (void)fetchContractNewPriceWithResult:(RequestResult)result {
    [self.arrayNewPriceDatas removeAllObjects];
    //合约最新成交价
    NSDictionary *params3 = @{@"symbol" : self.symbol};
    [Service fetchContractNewPriceWithParams:params3 mapper:[TradeListSubModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            NSArray *tempArray = responseModel.data;
            [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < 20) {
                    [self.arrayNewPriceDatas addObject:obj];
                }
            }];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"合约最新成交价失败");
        result(NO);
    }];
    
}

#pragma mark - Setter & Getter
- (NSMutableArray<QuotesModel *> *)arrayQuotesDatas {
    if (!_arrayQuotesDatas) {
        _arrayQuotesDatas = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayQuotesDatas;
}

- (NSMutableArray<TradeListSubModel *> *)arrayNewPriceDatas {
    if (!_arrayNewPriceDatas) {
        _arrayNewPriceDatas = [NSMutableArray arrayWithCapacity:20];
    }
    return _arrayNewPriceDatas;
}

@end
