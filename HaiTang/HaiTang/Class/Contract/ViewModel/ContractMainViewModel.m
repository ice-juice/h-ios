//
//  ContractMainViewModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/13.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ContractMainViewModel.h"
#import "Service.h"
#import "UserModel.h"
#import "RecordModel.h"
#import "SymbolModel.h"
#import "QuotesModel.h"
#import "TradeListModel.h"
#import "RecordSubModel.h"
#import "RecordListModel.h"

@implementation ContractMainViewModel
#pragma mark - Life Cycle
- (instancetype)initWithRecordType:(RecordType)recordType symbols:(nonnull NSString *)symbols {
    self = [super init];
    if (self) {
        _recordType = recordType;
        _symbols = symbols;
        _flowType = @"";
    }
    return self;;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _symbols = @"BTC/USDT";
        _contract_type = @"N";
        _showMethod = @"ALL";
        _compactId = @"";
        _dealWay = @"MARKET";
    }
    return self;
}

#pragma mark - Request Data
- (void)fetchRecordsWithResult:(RequestMoreResult)result {
    NSString *type = @"";
    if (self.recordType == RecordTypeContractAssets) {
        type = @"CONTRACT";
    } else if (self.recordType == RecordTypeWalletAssets) {
        type = @"WALLET";
    } else if (self.recordType == RecordTypeFiatAssets) {
        type = @"LEGAL";
    } else if (self.recordType == RecordTypeCoinAssets) {
        type = @"CURRENCY";
    }
    if ([self.symbols isEqualToString:NSLocalizedString(@"全部币种", nil)]) {
        self.symbols = @"";
    }
    
    //中文1 繁体2 英文3 韩语4
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLanguage];
//    if ([currentLanguage isEqualToString:Chinese_Simple]) {
//        currentLanguage = @"1";
//    } else
    if ([currentLanguage isEqualToString:Chinese_Traditional]) {
        currentLanguage = @"2";
    } else if ([currentLanguage isEqualToString:Korean]) {
        currentLanguage = @"3";
    } else if ([currentLanguage isEqualToString:Japanese]) {
        currentLanguage = @"4";
    } else {
        currentLanguage = @"5";
    }
    
    NSDictionary *params = @{@"type" : type,
                             @"current" : @(self.pageNo),
                             @"size" : @(self.pageSize),
                             @"symbols" : self.symbols,
                             @"flowType" : self.flowType,
                             @"languageType" : currentLanguage
    };
    [Service fetchRecordsWithParams:params mapper:[RecordListModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayRecordDatas removeAllObjects];
            }
            RecordListModel *listModel = responseModel.data;
            RecordModel *recordModel = listModel.records;
            NSArray *tempArray = recordModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayRecordDatas addObjectsFromArray:tempArray];
            }
            result(YES,[tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取流水记录失败");
        result(NO, NO);
    }];
}

- (void)fetchTypeWithResult:(RequestResult)result {
    __block BOOL success = YES;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    NSString *symbolType = @"FLOW";
    if (self.recordType == RecordTypeCloseing) {
        //平仓记录
        symbolType = @"CONTRACT";
    } else if (self.recordType == RecordTypeDeal) {
        //成交记录
        symbolType = @"CURRENCY";
    } else if (self.recordType == RecordTypeRecharge ||
               self.recordType == RecordTypeWithdraw) {
        //充币、提币币种
        symbolType = @"CHANGER";
    }
    NSDictionary *params = @{@"type" : symbolType};
    [Service fetchSymbolListWithParams:params mapper:[SymbolModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            SymbolModel *symbolModel = [[SymbolModel alloc] init];
            symbolModel.symbols = NSLocalizedString(@"全部币种", nil);
            NSMutableArray *arraySymbol = [NSMutableArray arrayWithCapacity:10];
            [arraySymbol addObject:symbolModel];
            [arraySymbol addObjectsFromArray:responseModel.data];
            self.arraySymbolDatas = [arraySymbol mutableCopy];
        } else {
            success = NO;
        }
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        dispatch_group_leave(group);
        Logger(@"获取全部币种失败");
        success = NO;
    }];
    
    dispatch_group_enter(group);
    NSString *type = @"";
    if (self.recordType == RecordTypeContractAssets) {
        type = @"CONTRACT";
    } else if (self.recordType == RecordTypeWalletAssets) {
        type = @"WALLET";
    } else if (self.recordType == RecordTypeFiatAssets) {
        type = @"LEGAL";
    } else if (self.recordType == RecordTypeCoinAssets) {
        type = @"CURRENCY";
    }
    NSDictionary *params0 = @{@"type" : type};
    [Service fetchRecordTypeWithParams:params0 mapper:[RecordSubModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            RecordSubModel *subModel = [[RecordSubModel alloc] init];
            subModel.code = @"";
            subModel.sources = @"全部类型";
            NSMutableArray *arrayTypeData = [NSMutableArray arrayWithCapacity:10];
            [arrayTypeData addObject:subModel];
            [arrayTypeData addObjectsFromArray:responseModel.data];
            self.arrayRecordTypeDatas = [arrayTypeData mutableCopy];
        } else {
            success = NO;
        }
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        dispatch_group_leave(group);
        Logger(@"获取流水类型失败");
        success = NO;
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        result(success);
    });
}

- (void)fetchRechargeOrWithdrawRecordWithResult:(RequestMoreResult)result {
    if ([self.symbols containsString:@"/USDT"]) {
        self.symbols = [self.symbols substringToIndex:self.symbols.length - 5];
    }
    if ([self.symbols containsString:NSLocalizedString(@"全部币种", nil)]) {
        self.symbols = @"";
    }
    NSString *type = self.recordType == RecordTypeRecharge ? @"R" : @"W";
    NSDictionary *params = @{@"current" : @(self.pageNo),
                             @"size" : @(self.pageSize),
                             @"symbol" : self.symbols,
                             @"type" : type
    };
    [Service fetchRechargeOrWithdrawRecordWithParams:params mapper:[RecordModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayRecordDatas removeAllObjects];
            }
            RecordModel *recordModel = responseModel.data;
            NSArray *tempArray = recordModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayRecordDatas addObjectsFromArray:tempArray];
            }
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取充币、提币记录失败");
        result(NO, NO);
    }];
}

- (void)fetchContractInfoWithResult:(RequestResult)result {
//    __block BOOL success = YES;
    
//    dispatch_group_t group = dispatch_group_create();
    
//    dispatch_group_enter(group);
    NSDictionary *params = @{@"symbols" : self.symbols};
    [Service fetchContractInfoWithParams:params mapper:[SymbolModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.contractInfoModel = responseModel.data;
            result(YES);
        }
//        else {
//            success = NO;
//        }
//        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
//        dispatch_group_leave(group);
        Logger(@"获取合约页面信息失败");
        result(NO);
//        success = NO;
    }];
    
//    dispatch_group_enter(group);
//    [Service fetchUserInfoWithParams:nil mapper:[UserModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
//        if (responseModel.data) {
//            UserModel *userModel = responseModel.data;
//            [[NSUserDefaults standardUserDefaults] setObject:userModel.inviteCode forKey:@"kInviteId"];
//            [[NSUserDefaults standardUserDefaults] setObject:userModel.inviteLink forKey:@"kInviteLink"];
//        } else {
//            success = NO;
//        }
//        dispatch_group_leave(group);
//    } failure:^(NSError * _Nonnull error) {
//        Logger(@"获取用户信息失败");
//        success = NO;
//        dispatch_group_leave(group);
//    }];
//
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        result(success);
//    });
}

- (void)fetchContractMarketWithResult:(RequestResult)result {
    NSDictionary *params0 = @{@"type" : @"1"};
    [Service fetchCurrencyQuotesWithParams:params0 mapper:[QuotesModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.arrayQuotesDatas = responseModel.data;
            [self.arrayQuotesDatas enumerateObjectsUsingBlock:^(QuotesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.type = @"1";
                if ([obj.symbol containsString:self.symbols]) {
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

- (void)fetchContractOrderListWithResult:(RequestMoreResult)result {
    NSDictionary *params2 = @{@"symbols" : self.symbols,
                              @"type" : self.contract_type,
                              @"current" : @(self.pageNo),
                              @"size" : @(self.pageSize),
                              @"showMethod" : self.showMethod,
                              @"buyMethod" : @"",
                              @"status" : @""
    };
    [Service fetchContractOrderListWithParams:params2 mapper:[RecordModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayContractOrderDatas removeAllObjects];
            }
            RecordModel *recordModel = responseModel.data;
            NSArray *tempArray = recordModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayContractOrderDatas addObjectsFromArray:tempArray];
            }
            
            [self.arrayContractOrderDatas enumerateObjectsUsingBlock:^(RecordSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                for (QuotesModel *quotesModel in self.arrayQuotesDatas) {
                    if ([obj.symbols isEqualToString:quotesModel.symbol]) {
                        obj.currentPrice = quotesModel.close;
                    }
                }
            }];
            
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取合约列表失败");
        result(NO, NO);
    }];
}

- (void)fetchSubmitContractWithResult:(RequestResult)result {
    NSDictionary *params = @{@"symbols" : self.symbols,
                             @"unit" : self.unitPrice,
                             @"numbers" : self.numbers,
                             @"compactType" : self.compactType,
                             @"dealWay" : self.dealWay,
                             @"leverageId" : self.leverageId,
                             @"coin" : @"USDT"
    };
    [Service fetchSubmitContractWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"合约交易失败");
        result(NO);
    }];
}

- (void)fetchCloseingWithResult:(RequestResult)result {
    NSDictionary *params = @{@"compactId" : self.compactId,
                             @"type" : self.operationType,
                             @"number" : self.numbers
    };
    [Service fetchCloseingWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"平仓失败");
        result(NO);
    }];
}

- (void)fetchCancelContractWithResult:(RequestResult)result {
    NSDictionary *params = @{@"compactId" : self.compactId,
                             @"type" : self.operationType
    };
    [Service fetchCancelContractWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"撤销合约委托失败");
        result(NO);
    }];
}

- (void)fetchTakeProfit:(NSString *)profitPrice stopLoss:(NSString *)lossPrice result:(RequestResult)result {
    if ([NSString isEmpty:self.compactId]) {
        return;
    }
    NSDictionary *params = @{@"compactId" : self.compactId,
                             @"stopLoss" : lossPrice,
                             @"stopProfit" : profitPrice
    };
    [Service fetchTabkeProfitAndStopLossWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"设置止盈止损失败");
        result(NO);
    }];
}

- (void)fetchCloseingRecordsWithResult:(RequestMoreResult)result {
    NSString *buyMethod = @"";
    if ([self.compactType isEqualToString:NSLocalizedString(@"多仓", nil)]) {
        buyMethod = @"BUY";
    } else if([self.compactType isEqualToString:NSLocalizedString(@"空仓", nil)]) {
        buyMethod = @"SELL";
    }
    
    NSString *status = @"";
    if ([self.closeingStatus isEqualToString:NSLocalizedString(@"手动平仓", nil)]) {
        status = @"HANDLE";
    } else if ([self.closeingStatus isEqualToString:NSLocalizedString(@"强制平仓", nil)]) {
        status = @"FIXED";
    } else if ([self.closeingStatus isEqualToString:NSLocalizedString(@"止盈平仓", nil)]) {
        status = @"PROFIT";
    } else if ([self.closeingStatus isEqualToString:NSLocalizedString(@"止损平仓", nil)]) {
        status = @"LOSS";
    }
    
    NSDictionary *params = @{@"current" : @(self.pageNo),
                             @"size" : @(self.pageSize),
                             @"type" : @"Y",
                             @"showMethod" : @"",
                             @"symbols" : self.symbols,
                             @"buyMethod" : buyMethod,
                             @"status" : status
    };
    [Service fetchContractOrderListWithParams:params mapper:[RecordModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayRecordDatas removeAllObjects];
            }
            RecordModel *recordModel = responseModel.data;
            NSArray *tempArray = recordModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayRecordDatas addObjectsFromArray:tempArray];
            }
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取平仓记录失败");
        result(NO, NO);
    }];
}

- (void)fetchCurrencyRecordsWithResult:(RequestMoreResult)result {
    NSString *buyMethod = @"5";
    if ([self.compactType isEqualToString:NSLocalizedString(@"买入", nil)]) {
        buyMethod = @"2";
    } else if([self.compactType isEqualToString:NSLocalizedString(@"卖出", nil)]) {
        buyMethod = @"3";
    } else if ([self.compactType isEqualToString:NSLocalizedString(@"撤销", nil)]) {
        buyMethod = @"4";
    }
    
    if ([self.symbols isEqualToString:NSLocalizedString(@"全部币种", nil)]) {
        self.symbols = @"";
    }
    
    NSDictionary *params = @{@"type" : buyMethod,
                             @"current" : @(self.pageNo),
                             @"size" : @(self.pageSize),
                             @"symbols" : self.symbols
    };
    [Service fetchCoinCommissionOrRecordsWithParams:params mapper:[RecordModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayRecordDatas removeAllObjects];
            }
            RecordModel *recordModel = responseModel.data;
            NSArray *tempArray = recordModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayRecordDatas addObjectsFromArray:tempArray];
            }
            [self.arrayRecordDatas enumerateObjectsUsingBlock:^(RecordSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.type = buyMethod;
            }];
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取成交记录失败");
        result(NO, NO);
    }];
}

#pragma mark - Setter & Getter
- (NSMutableArray<RecordSubModel *> *)arrayRecordDatas {
    if (!_arrayRecordDatas) {
        _arrayRecordDatas = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayRecordDatas;
}

- (NSMutableArray<RecordSubModel *> *)arrayContractOrderDatas {
    if (!_arrayContractOrderDatas) {
        _arrayContractOrderDatas = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayContractOrderDatas;
}

@end
