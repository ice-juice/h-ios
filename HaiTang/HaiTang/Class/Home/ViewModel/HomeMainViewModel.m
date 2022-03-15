//
//  HomeMainViewModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "HomeMainViewModel.h"
#import "HomeTableModel.h"
#import "Service.h"
#import "NewModel.h"
#import "DataModel.h"
#import "UserModel.h"
#import "ImageModel.h"
#import "QuotesModel.h"
#import "BannerModel.h"
#import "NewListModel.h"
#import "UserInfoManager.h"
#import "PaymentTableModel.h"
#import "SecuritySettingsTableModel.h"

#import "GCDManager.h"
#import "CacheManager.h"

@implementation HomeMainViewModel
#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _cardType = @"身份证";
        _quotesType = @"1";
    }
    return self;
}

- (instancetype)initWithBindType:(BindType)bindType {
    self = [super init];
    if (self) {
        _bindType = bindType;
        _code = @"86";
    }
    return self;
}

- (instancetype)initWithAddPaymentType:(AddPaymentType)addPaymentType {
    self = [super init];
    if (self) {
        _addPaymentType = addPaymentType;
        _frontImg = @"";
    }
    return self;
}

- (instancetype)initWithModifyType:(NSInteger)modifyType {
    self = [super init];
    if (self) {
        _modifyType = modifyType;
    }
    return self;
}

#pragma mark - External Interface
- (BOOL)hasCacheData {
    //获取上次缓存的数据
    NSArray *arrayBanners = (NSArray *)[[CacheManager sharedManager] getArrayDatasFromCachePaths:kBannerCathPath];
    if (arrayBanners && [arrayBanners count]) {
        self.arrayBannerDatas = arrayBanners;
        return YES;
    }
    return NO;
}

- (void)loadPersonalTableDatas {
    [self.arrayPersonalTableDatas removeAllObjects];
    
    NSString *tableModel1SubTitle = @"未认证";
    if ([self.userModel.realStatus isEqualToString:@"1"]) {
        tableModel1SubTitle = @"已认证";
    } else if ([self.userModel.realStatus isEqualToString:@"2"]) {
        tableModel1SubTitle = @"审核中";
    }
    
    BaseTableModel *tableModel0 = [[BaseTableModel alloc] initWithImageName:@"grzx_aq" title:@"安全设置"];
    BaseTableModel *tableModel1 = [[BaseTableModel alloc] initWithImageName:@"grzx_sfrz" title:@"身份验证" subTitle:tableModel1SubTitle];
    BaseTableModel *tableModel2 = [[BaseTableModel alloc] initWithImageName:@"grzx_yqlj" title:@"邀请链接"];
    BaseTableModel *tableModel3 = [[BaseTableModel alloc] initWithImageName:@"grzx_yyqh" title:@"语言切换"];
    BaseTableModel *tableModel4 = [[BaseTableModel alloc] initWithImageName:@"grzx_lxkf" title:@"联系客服"];
    BaseTableModel *tableModel5 = [[BaseTableModel alloc] initWithImageName:@"grzx_gywm" title:@"关于我们"];
//    BaseTableModel *tableModel6 = [[BaseTableModel alloc] initWithImageName:@"grzx_bps" title:@"白皮书"];

    [self.arrayPersonalTableDatas addObjectsFromArray:@[@[tableModel0, tableModel1], @[tableModel2, tableModel3], @[tableModel4, tableModel5]]];
}

- (void)loadSecurityTableDatas {
    [self.arraySecurityTableDatas removeAllObjects];
    
    NSString *tableModel1SubTitle = [NSString isEmpty:self.userModel.phone] ? @"绑定" : [self.userModel.phone stringByReplacingString:self.userModel.phone];
    NSString *isBinding1 = [NSString isEmpty:self.userModel.phone] ? @"N" : @"Y";
    
    NSString *tableModel2SubTitle = [NSString isEmpty:self.userModel.email] ? @"绑定" : [self.userModel.email stringByReplacingString:self.userModel.email];
    NSString *isBinding2 = [NSString isEmpty:self.userModel.email] ? @"N" : @"Y";
    
    NSString *tableModel5SubTitle = [self.userModel.isOpenPay isEqualToString:@"Y"] ? @"已开启" : @"未开启";
    
    SecuritySettingsTableModel *tableModel0 = [[SecuritySettingsTableModel alloc] initWithTitle:@"登录密码" subTitle:@"修改"];
    SecuritySettingsTableModel *tableModel1 = [[SecuritySettingsTableModel alloc] initWithTitle:@"手机验证" subTitle:tableModel1SubTitle isBinding:isBinding1];
    SecuritySettingsTableModel *tableModel2 = [[SecuritySettingsTableModel alloc] initWithTitle:@"邮箱验证" subTitle:tableModel2SubTitle isBinding:isBinding2];
    SecuritySettingsTableModel *tableModel3 = [[SecuritySettingsTableModel alloc] initWithTitle:@"法币收款方式设置"];
    SecuritySettingsTableModel *tableModel4 = [[SecuritySettingsTableModel alloc] initWithTitle:@"法币交易昵称"];
    SecuritySettingsTableModel *tableModel5 = [[SecuritySettingsTableModel alloc] initWithTitle:@"资产密码(法币、转账)" subTitle:tableModel5SubTitle];
    [self.arraySecurityTableDatas addObjectsFromArray:@[@[tableModel0, tableModel1, tableModel2], @[tableModel3, tableModel4, tableModel5]]];
}

- (void)loadPaymentTableDatas {
    [self.arrayPaymentTableDatas removeAllObjects];
//    BaseTableModel *tableModel0 = [[BaseTableModel alloc] initWithImageName:@"zfb" title:@"支付宝"];
//    BaseTableModel *tableModel1 = [[BaseTableModel alloc] initWithImageName:@"wx" title:@"微信"];
    PaymentTableModel *tableModel2 = [[PaymentTableModel alloc] initWithImageName:@"yhk" title:@"银行卡" addPaymentType:AddPaymentTypeBankCard];
//    BaseTableModel *tableModel3 = [[BaseTableModel alloc] initWithImageName:@"paypal" title:@"PayPal"];
    
    //2021-02-05
    [self.arrayPaymentTableDatas addObjectsFromArray:@[tableModel2]];
}

#pragma mark - Request Data
- (void)fetchHomeInfoWithResult:(RequestResult)result {
    [self.arrayNewDatas removeAllObjects];
    
    __block BOOL success = YES;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    NSDictionary *params = @{@"size" : @(self.pageSize),
                             @"current" : @(self.pageNo),
                             @"status" : @"Y"
    };
    [Service fetchNewsListWithParams:params mapper:[NewListModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            NewListModel *listModel = responseModel.data;
            NSArray *tempArray = listModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayNewDatas addObjectsFromArray:listModel.records];
            }
        } else {
            success = NO;
        }
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取平台公告失败");
        dispatch_group_leave(group);
        success = NO;
    }];
    
    dispatch_group_enter(group);
    [Service fetchBannerListWithParams:nil mapper:[BannerModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.arrayBannerDatas = responseModel.data;
            if (self.arrayBannerDatas && [self.arrayBannerDatas count]) {
                [[GCDManager sharedManager] addAsyncTask:^{
                    [[CacheManager sharedManager] saveArrayDatas:self.arrayBannerDatas toCachePaths:kBannerCathPath];
                }];
            }
        } else {
            success = NO;
        }
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取轮播图列表失败");
        dispatch_group_leave(group);
        success = NO;
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        result(success);
    });
}

- (void)fetchNoticeListWithResult:(RequestMoreResult)result {
    NSDictionary *params = @{@"size" : @(self.pageSize),
                             @"current" : @(self.pageNo),
                             @"status" : @"N"
    };
    [Service fetchNewsListWithParams:params mapper:[NewListModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayNewDatas removeAllObjects];
            }
            NewListModel *listModel = responseModel.data;
            NSArray *tempArray = listModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayNewDatas addObjectsFromArray:listModel.records];
            }
            [self calculatedNewHeight];
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取平台公告失败");
        result(NO, NO);
    }];
}

- (void)fetchHelpListWithResult:(RequestMoreResult)result {
    NSDictionary *params = @{@"type" : @"HELP",
                             @"current" : @(self.pageNo),
                             @"size" : @(self.pageSize)
    };
    [Service fetchHelpListWithParams:params mapper:[NewListModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayNewDatas removeAllObjects];
            }
            NewListModel *listModel = responseModel.data;
            NSArray *tempArray = listModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayNewDatas addObjectsFromArray:tempArray];
            }
            [self calculatedNewHeight];
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取帮助中心失败");
        result(NO, NO);
    }];
}

- (void)fetchUserInfoWithResult:(RequestResult)result {
    [Service fetchUserInfoWithParams:nil mapper:[UserModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.userModel = responseModel.data;
            [[UserInfoManager sharedManager] setUserInfo:responseModel.data];
            [self loadPersonalTableDatas];
            [self loadSecurityTableDatas];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取用户信息失败");
        result(NO);
    }];
}

- (void)fetchInviteFriendsInfoWithResult:(RequestResult)result {
    [Service fetchUserInfoWithParams:nil mapper:[UserModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.userModel = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取用户信息失败");
        result(NO);
    }];
}

- (void)fetchUpdatePassword:(NSString *)msgOrOldPassword result:(RequestResult)result {
    if ([NSString isEmpty:self.password]) {
        return;
    }
    NSString *type = self.modifyType == ModifyTypeLoginPassword ? @"LOGIN" : @"PAY";
    NSDictionary *params = @{@"newPwd" : self.password,
                             @"confirmPwd" : self.password,
                             @"msgOrOldPwd" : msgOrOldPassword,
                             @"type" : type
    };
    [Service fetchUpdateNewPasswordWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"修改登录密码或资产密码失败");
        result(NO);
    }];
}

- (void)sendVerifyCodeCountDown:(void (^)(NSString * _Nonnull, BOOL))block result:(RequestResult)result {
    NSString *code = self.code;
    
    if ([NSString isEmpty:self.account]) {
        self.account = @"";
        code = @"";
    }
    //2020-11-26 账号为空
    NSDictionary *params = @{@"account" : self.account,
                             @"code" : code
    };
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

- (void)fetchNickName:(NSString *)nickName result:(RequestResult)result {
    NSDictionary *params = @{@"nickName" : nickName};
    [Service fetchNickNameWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"设置昵称失败");
        result(NO);
    }];
}

- (void)fetchVerificationCode:(NSString *)verifyCode result:(RequestResult)result {
    NSDictionary *params = @{@"account" : [UserInfoManager sharedManager].account,
                             @"code" : verifyCode
    };
    [Service fetchVerificationCodeWithParams:params mapper:[DataModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.dataModel = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"检验验证码失败");
        result(NO);
    }];
}

- (void)fetchBindingAccount:(NSString *)verifyCode result:(RequestResult)result {
    if ([NSString isEmpty:self.account]) {
        return;
    }
    NSDictionary *params = @{@"bindAccount" : self.account,
                             @"msg" : verifyCode
    };
    [Service fetchBindingAccountWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"账号绑定失败");
        result(NO);
    }];
}

- (void)fetchLogoutWithResult:(RequestResult)result {
    [Service fetchLogoutWithParams:nil mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"退出登录失败");
        result(NO);
    }];
}

- (void)fetchCollectionSettingsWithResult:(RequestMoreResult)result {
    NSDictionary *params = @{@"size" : @(self.pageSize),
                             @"current" : @(self.pageNo)
    };
    [Service fetchCollectionSettingsWithParams:params mapper:[NewListModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayCollectionDatas removeAllObjects];
            }
            NewListModel *listModel = responseModel.data;
            NSArray *tempArray = listModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayCollectionDatas addObjectsFromArray:tempArray];
            }
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        result(NO, NO);
        Logger(@"获取收款方式失败");
    }];
}

- (void)fetchUploadIDCardPicture:(UIImage *)image isPositive:(BOOL)isPositive result:(RequestResult)result {
    NSArray *imageArray = @[image];
    [Service uploadImageWithParams:nil imageArray:imageArray mapper:[ImageModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            ImageModel *imgModel = responseModel.data;
            if (isPositive) {
                //人脸照片
                self.frontImg = imgModel.src;
            } else {
                //国徽
                self.backImg = imgModel.src;
            }
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"上传身份证失败");
        result(NO);
    }];
}

- (void)fetchRealNameVerifyWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.idCard]) {
        return;
    }
    NSDictionary *params = @{@"idCard" : self.idCard,
                             @"fistName" : self.fistName,
                             @"lastName" : self.lastName,
                             @"type" : self.cardType,
                             @"frontImg" : self.frontImg,
                             @"backImg" : self.backImg
    };
    [Service fetchRealNameVerifyWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"实名认证失败");
        result(NO);
    }];
}

- (void)fetchAddPayment:(NSString *)name address:(NSString *)address result:(RequestResult)result {
    if ([NSString isEmpty:self.idCard]) {
        return;
    }
    NSString *type = @"PAYPAL";
    if (self.addPaymentType == AddPaymentTypeAlipay) {
        type = @"ALI_PAY";
    } else if (self.addPaymentType == AddPaymentTypeWeChat) {
        type = @"WE_CHAT";
    } else if (self.addPaymentType == AddPaymentTypeBankCard) {
        type = @"BANK";
    }
    NSDictionary *params = @{@"idcard" : self.idCard,
                             @"img" : self.frontImg,
                             @"bank" : name,
                             @"branch" : address,
                             @"type" : type,
                             @"name" : self.fistName
    };
    [Service fetchAddPaymentWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"添加收款方式失败");
        result(NO);
    }];
}

- (void)fetchDeletePayment:(NSString *)paymentId result:(RequestResult)result {
    if ([NSString isEmpty:paymentId]) {
        return;
    }
    NSDictionary *params = @{@"paymentId" : paymentId};
    [Service fetchDeletePaymentWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"删除收款方式失败");
        result(NO);
    }];
}

- (void)fetchQuotesWithResult:(RequestResult)result {
    NSDictionary *params1 = @{@"type" : self.quotesType};
    [Service fetchCurrencyQuotesWithParams:params1 mapper:[QuotesModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.arrayQuotesDatas = responseModel.data;
            [self.arrayQuotesDatas enumerateObjectsUsingBlock:^(QuotesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.type = self.quotesType;
            }];
            NSInteger count = [self.arrayQuotesDatas count];
            self.scrollViewHeight = 697.5 + 60 * count;
            self.homeQuotesHeight = 85 + 60 * count;
            
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取币种行情失败");
        result(NO);
    }];
}

- (void)fetchServiceWithResult:(RequestResult)result {
    [Service fetchServiceWithParams:nil mapper:nil showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.serviceString = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取联系客服失败");
        result(NO);
    }];
}

- (void)fetchContractPricesWithResult:(RequestResult)result {
    NSDictionary *params1 = @{@"type" : @"1"};
    [Service fetchCurrencyQuotesWithParams:params1 mapper:[QuotesModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.arrayContractPrices = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取合约行情失败");
        result(NO);
    }];
}

#pragma mark - 计算公告平台高度
- (void)calculatedNewHeight {
    [self.arrayNewDatas enumerateObjectsUsingBlock:^(NewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = 0;
        height = [obj.title heightForFont:kBoldFont(14) maxWidth:kScreenWidth - 90] + 63;
        obj.cellHeight = height;
    }];
}

#pragma mark - PrivateMethod
- (void)startCountDownWithBlock:(void (^)(NSString * _Nonnull, BOOL))block {
    int countdownSecond = 0;
    if ([NSString isEmpty:self.account]) {
        //第一遍获取账号验证码，根据登录方式判断验证码时长
        countdownSecond = [[UserInfoManager sharedManager].loginMethod isEqualToString:@"PHONE"] ? kCountdownSecond : kEmailCountdownSecond;
    } else {
        //第二遍根据需要绑定的账号判断验证码时长
        countdownSecond = [self.account containsString:@"@"] ? kEmailCountdownSecond : kCountdownSecond;
    }
    
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
- (NSMutableArray<HomeTableModel *> *)arrayTableDatas {
    if (!_arrayTableDatas) {
        _arrayTableDatas = [NSMutableArray arrayWithCapacity:3];
    }
    return _arrayTableDatas;
}

- (NSMutableArray<NSArray *> *)arrayPersonalTableDatas {
    if (!_arrayPersonalTableDatas) {
        _arrayPersonalTableDatas = [NSMutableArray arrayWithCapacity:3];
    }
    return _arrayPersonalTableDatas;
}

- (NSMutableArray<NSArray *> *)arraySecurityTableDatas {
    if (!_arraySecurityTableDatas) {
        _arraySecurityTableDatas = [NSMutableArray arrayWithCapacity:2];
    }
    return _arraySecurityTableDatas;
}

- (NSMutableArray<PaymentTableModel *> *)arrayPaymentTableDatas {
    if (!_arrayPaymentTableDatas) {
        _arrayPaymentTableDatas = [NSMutableArray arrayWithCapacity:4];
    }
    return _arrayPaymentTableDatas;
}

- (NSMutableArray<NewModel *> *)arrayNewDatas {
    if (!_arrayNewDatas) {
        _arrayNewDatas = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayNewDatas;
}

- (NSMutableArray<NewModel *> *)arrayCollectionDatas {
    if (!_arrayCollectionDatas) {
        _arrayCollectionDatas = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayCollectionDatas;
}

@end
