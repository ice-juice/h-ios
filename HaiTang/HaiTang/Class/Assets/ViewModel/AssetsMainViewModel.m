//
//  AssetsMainViewModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "AssetsMainViewModel.h"
#import "BaseTableModel.h"
#import "Service.h"
#import "UserModel.h"
#import "ImageModel.h"
#import "AssetsModel.h"
#import "SymbolModel.h"
#import "AddressModel.h"

@implementation AssetsMainViewModel
#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _usdtAssetsType = USDTAssetsTypeWallet;
    }
    return self;
}

- (instancetype)initWithSymbol:(NSString *)symbol type:(nonnull NSString *)type {
    self = [super init];
    if (self) {
        _symbol = symbol;
        _smsCode = @"";
        _emailCode = @"";
        _memoOrTagValue = @"";
        _from = @"钱包账户";
        _to = @"币币账户";
        _type = type;
    }
    return self;
}

- (instancetype)initWithSymbol:(NSString *)symbol {
    return [self initWithSymbol:symbol type:@""];
}

- (instancetype)initWithUSDTAssetsType:(USDTAssetsType)usdtAssetsType list_id:(nonnull NSString *)list_id {
    self = [super init];
    if (self) {
        _usdtAssetsType = usdtAssetsType;
        _list_id = list_id;
    }
    return self;
}

- (void)loadUSDTAssetsTableDatas {
    [self.arrayUSDTAssetsTableDatas removeAllObjects];
    BaseTableModel *tableModel0 = [[BaseTableModel alloc] initWithTitle:@"总额" subTitle:[NSString stringWithFormat:@"%.8f", [self.assetsDetailModel.p1 doubleValue]]];
    BaseTableModel *tableModel1 = [[BaseTableModel alloc] initWithTitle:@"冻结" subTitle:[NSString stringWithFormat:@"%.8f", [self.assetsDetailModel.p2 doubleValue]]];
    BaseTableModel *tableModel2 = [[BaseTableModel alloc] initWithTitle:@"可用" subTitle:[NSString stringWithFormat:@"%.8f", [self.assetsDetailModel.p3 doubleValue]]];
    BaseTableModel *tableModel3 = [[BaseTableModel alloc] initWithTitle:@"权益账户" subTitle:[NSString stringWithFormat:@"%.8f", [self.assetsDetailModel.p1 doubleValue]]];
    BaseTableModel *tableModel4 = [[BaseTableModel alloc] initWithTitle:@"未实现盈亏" subTitle:[NSString stringWithFormat:@"%.8f", [self.assetsDetailModel.p2 doubleValue]]];
    BaseTableModel *tableModel5 = [[BaseTableModel alloc] initWithTitle:@"仓位保证金" subTitle:[NSString stringWithFormat:@"%.8f", [self.assetsDetailModel.p3 doubleValue]]];
    BaseTableModel *tableModel6 = [[BaseTableModel alloc] initWithTitle:@"委托保证金" subTitle:[NSString stringWithFormat:@"%.8f", [self.assetsDetailModel.p5 doubleValue]]];
    BaseTableModel *tableModel7 = [[BaseTableModel alloc] initWithTitle:@"可用保证金" subTitle:[NSString stringWithFormat:@"%.8f", [self.assetsDetailModel.p4 doubleValue]]];
    if (self.usdtAssetsType == USDTAssetsTypeContract) {
        //USDT合约资产
        [self.arrayUSDTAssetsTableDatas addObjectsFromArray:@[tableModel3, tableModel4, tableModel5, tableModel6, tableModel7]];
    } else {
        [self.arrayUSDTAssetsTableDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2]];
    }
}

#pragma mark - Request Data
- (void)fetchAssetsInfoWithResult:(RequestResult)result {
    NSString *type = @"WALLET";
    if (self.usdtAssetsType == USDTAssetsTypeCoin) {
        type = @"CURRENCY";
    } else if (self.usdtAssetsType == USDTAssetsTypeFiat) {
        type = @"LEGAL";
    } else if (self.usdtAssetsType == USDTAssetsTypeContract) {
        type = @"CONTRACT";
    }
    NSDictionary *params = @{@"valuation" : @"USDT",
                             @"hide" : @"N",
                             @"type" : type
    };
    [Service fetchAssetsInfoWithParams:params mapper:[AssetsModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.assetsModel = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取个人资产信息失败");
        result(NO);
    }];
}

- (void)fetchAssetsDetailWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.list_id]) {
        return;
    }
    NSString *type = @"WALLET";
    if (self.usdtAssetsType == USDTAssetsTypeCoin) {
        type = @"CURRENCY";
    } else if (self.usdtAssetsType == USDTAssetsTypeFiat) {
        type = @"LEGAL";
    } else if (self.usdtAssetsType == USDTAssetsTypeContract) {
        type = @"CONTRACT";
    }
    NSDictionary *params = @{@"id" : self.list_id,
                             @"type" : type
    };
    [Service fetchAssetsDetailWithParams:params mapper:[AssetsModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.assetsDetailModel = responseModel.data;
            [self loadUSDTAssetsTableDatas];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取资产详情失败");
        result(NO);
    }];
}

- (void)fetchRechargeAddressWithResult:(RequestResult)result {
    NSDictionary *params = @{@"symbol" : self.symbol};
    [Service fetchRechargeAddressWithParams:params mapper:[AddressModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.rechargeAddressModel = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取充值地址失败");
        result(NO);
    }];
}

- (void)fetchSymbolListWithResult:(RequestResult)result {
    NSDictionary *params = @{@"type" : self.type};
    [Service fetchSymbolListWithParams:params mapper:[SymbolModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.arraySymbolDatas = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取全部币种失败");
        result(NO);
    }];
}

- (void)fetchWithdrawInfoWithResult:(RequestResult)result {
    NSDictionary *params = @{@"type" : self.symbol};
    [Service fetchWithdrawInfoWithParams:params mapper:[AssetsModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.withdrawInfoModel = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取提币页面信息失败");
        result(NO);
    }];
}

- (void)fetchUserInfoDataWithResult:(RequestResult)result {
    [Service fetchUserInfoWithParams:nil mapper:[UserModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.userModel = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取用户信息失败");
        result(NO);
    }];
}

- (void)sendVerifyCodeCountDown:(void (^)(NSString * _Nonnull, BOOL))block result:(RequestResult)result {
    NSDictionary *params = @{@"account" : self.account};
    [Service sendVerifyCodeWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            [self startCountDownWithBlock:block];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取验证码失败");
        result(NO);
    }];
}

- (void)fetchSubmitWithdrawWithResult:(RequestResult)result {
    NSDictionary *params = @{@"toAddress" : self.toAddress,
                             @"type" : self.symbol,
                             @"price" : self.price,
                             @"payPwd" : self.payPwd,
                             @"smsCode" : self.smsCode,
                             @"emailCode" : self.emailCode,
                             @"memoTagValue" : self.memoOrTagValue
    };
    [Service fetchSubmitWithdrawWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"提币失败");
        result(NO);
    }];
}

- (void)fetchTransferInfoWithResult:(RequestResult)result {
    NSString *from = @"WALLET";
    if ([self.from isEqualToString:NSLocalizedString(@"合约账户", nil)]) {
        from = @"CONTRACT";
    } else if ([self.from isEqualToString:NSLocalizedString(@"币币账户", nil)]) {
        from = @"CURRENCY";
    } else if ([self.from isEqualToString:NSLocalizedString(@"法币账户", nil)]) {
        from = @"LEGAL";
    }
    NSDictionary *params = @{@"type" : self.symbol,
                             @"from" : from
    };
    [Service fetchTransferInfoWithParams:params mapper:[AssetsModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.transferInfoModel = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取资产划转信息失败");
        result(NO);
    }];
}

- (void)fetchSubmitTransferWith:(NSString *)number result:(RequestResult)result {
    NSString *from = @"WALLET";
    NSString *to = @"CURRENCY";
    if ([self.from isEqualToString:NSLocalizedString(@"合约账户", nil)]) {
        from = @"CONTRACT";
    } else if ([self.from isEqualToString:NSLocalizedString(@"币币账户", nil)]) {
        from = @"CURRENCY";
    } else if ([self.from isEqualToString:NSLocalizedString(@"法币账户", nil)]) {
        from = @"LEGAL";
    }
    if ([self.to isEqualToString:NSLocalizedString(@"合约账户", nil)]) {
        to = @"CONTRACT";
    } else if ([self.to isEqualToString:NSLocalizedString(@"钱包账户", nil)]) {
        to = @"WALLET";
    } else if ([self.to isEqualToString:NSLocalizedString(@"法币账户", nil)]) {
        to = @"LEGAL";
    }
    
    NSDictionary *params = @{@"type" : self.symbol,
                             @"from" : from,
                             @"to" : to,
                             @"numbers" : number
    };
    [Service fetchSubmitTransferWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"资产划转失败");
        result(NO);
    }];
}

- (void)uploadPhotoFilesWith:(NSArray *)images withResult:(RequestResult)result {
    [self.arrayImageDatas removeAllObjects];
    [Service uploadImageWithParams:nil imageArray:images mapper:[ImageModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            ImageModel *imgModel = responseModel.data;
            [self.arrayImageDatas addObject:imgModel.src];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"上传图片失败");
        result(NO);
    }];
}

- (void)fetchSubmitRechargeWithResult:(RequestResult)result {
    NSDictionary *params = @{@"type" : self.symbol,
                             @"address" : self.toAddress,
                             @"price" : self.price,
                             @"remark" : self.remark
    };
    [Service fetchSubmitRechargeWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"充币失败");
        result(NO);
    }];
}

#pragma mark - PrivateMethod
- (void)startCountDownWithBlock:(void (^)(NSString * _Nonnull, BOOL))block {
    
    int countdownSecond = [self.account containsString:@"@"] ? kEmailCountdownSecond : kCountdownSecond;
    
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        
        NSTimeInterval countdownTime = currentTime - startTime;
        
        NSInteger retainTime = countdownSecond - countdownTime;
        if (retainTime > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    block([NSString stringWithFormat:@"已发送(%02ld)", retainTime], NO);
                }
            });
            
        } else {
            //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    block([NSString stringWithFormat:@"重新发送"], YES);
                }
            });
        }
        
    });
    dispatch_resume(_timer);
}

- (void)stopCountDown {
    //停止倒计时
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

#pragma mark - Setter & Getter
- (NSMutableArray<BaseTableModel *> *)arrayUSDTAssetsTableDatas {
    if (!_arrayUSDTAssetsTableDatas) {
        _arrayUSDTAssetsTableDatas = [NSMutableArray arrayWithCapacity:5];
    }
    return _arrayUSDTAssetsTableDatas;
}

- (NSMutableArray<NSString *> *)arrayImageDatas {
    if (!_arrayImageDatas) {
        _arrayImageDatas = [NSMutableArray arrayWithCapacity:3];
    }
    return _arrayImageDatas;
}

@end
