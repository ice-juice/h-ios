//
//  CoinMainViewModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "CoinMainViewModel.h"
#import "Service.h"
#import "SymbolModel.h"
#import "QuotesModel.h"
#import "RecordModel.h"
#import "TradeListModel.h"
#import "RecordSubModel.h"

@implementation CoinMainViewModel
#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _type = @"BTC/USDT";
        _matchType = @"BUY";
        _dealWay = @"MARKET";
    }
    return self;
}

#pragma mark - Request Data
- (void)fetchCoinInfoWithResult:(RequestResult)result {
    NSDictionary *params = @{@"type" : self.type,
                             @"matchType" : self.matchType
    };
    [Service fetchCoinInfoWithParams:params mapper:[SymbolModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.coinInfoModel = responseModel.data;
            self.coinInfoModel.symbols = self.type;
            self.coinInfoModel.matchType = self.matchType;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取币币交易信息失败");
        result(NO);
    }];
}

- (void)fetchCommissionWithResult:(RequestMoreResult)result {
    NSDictionary *params = @{@"type" : @"1",
                             @"current" : @(self.pageNo),
                             @"size" : @(self.pageSize),
                             @"symbols" : @""
    };
    [Service fetchCoinCommissionOrRecordsWithParams:params mapper:[RecordModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayCommOrRecordDatas removeAllObjects];
            }
            RecordModel *recordModel = responseModel.data;
            NSArray *tempArray = recordModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayCommOrRecordDatas addObjectsFromArray:tempArray];
            }
            [self.arrayCommOrRecordDatas enumerateObjectsUsingBlock:^(RecordSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.type = @"1";
            }];
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取币币委托、记录失败");
        result(NO, NO);
    }];
}

- (void)fetchQuotesWithResult:(RequestResult)result {
    NSDictionary *params0 = @{@"type" : @"0"};
    [Service fetchCurrencyQuotesWithParams:params0 mapper:[QuotesModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.arrayQuotesDatas = responseModel.data;
            [self.arrayQuotesDatas enumerateObjectsUsingBlock:^(QuotesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.type = @"0";
                if ([obj.symbol containsString:self.type]) {
                    self.currentQuotesModel = obj;
                }
            }];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取币种行情失败");
        result(NO);
    }];
}

- (void)fetchSubmitDealWithPrice:(NSString *)price number:(NSString *)number result:(RequestResult)result {
    NSDictionary *params = @{@"unit" : price,
                             @"number" : number,
                             @"matchType" : self.matchType,
                             @"dealWay" : self.dealWay,
                             @"symbols" : self.type
    };
    [Service fetchSubmitCoinDealWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"币币交易失败");
        result(NO);
    }];
}

- (void)fetchRevocationCommissionWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.compactId]) {
        return;
    }
    NSDictionary *params = @{@"matchId" : self.compactId};
    [Service fetchRevocationCommissionWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"撤销委托失败");
        result(NO);
    }];
}

#pragma mark - Setter & Getter
- (NSMutableArray<RecordSubModel *> *)arrayCommOrRecordDatas {
    if (!_arrayCommOrRecordDatas) {
        _arrayCommOrRecordDatas = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayCommOrRecordDatas;
}

- (void)setCompactId:(NSString *)compactId {
    _compactId = compactId;
}

@end
