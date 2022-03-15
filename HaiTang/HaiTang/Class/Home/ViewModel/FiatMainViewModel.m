//
//  FiatMainViewModel.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "FiatMainViewModel.h"
#import "BaseTableModel.h"
#import "Service.h"
#import "PaymentMethodModel.h"
#import "ImageModel.h"
#import "NewModel.h"
#import "OrderModel.h"
#import "AcceptorModel.h"
#import "OrderListModel.h"
#import "FiatOrderDetailTableModel.h"

@implementation FiatMainViewModel
#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _orderType = 0;
        _payMethod = @"";
        _price = @"";
        _number = @"";
    }
    return self;
}

- (instancetype)initWithDepositStatus:(MyDepositStatus)depositStatus {
    self = [super init];
    if (self) {
        _depositStatus = depositStatus;
    }
    return self;
}

- (instancetype)initWithOrderNo:(NSString *)orderNo {
    return [self initWithOrderNo:orderNo pageType:@""];
}

- (instancetype)initWithOrderNo:(NSString *)orderNo pageType:(NSString *)pageType {
    self = [super init];
    if (self) {
        _orderNo = orderNo;
        _pageType = pageType;
    }
    return self;
}

- (instancetype)initWithOrderStatus:(FiatOrderStatus)orderStatus orderType:(NSInteger)orderType {
    self = [super init];
    if (self) {
        _orderStatus = orderStatus;
        _orderType = orderType;
    }
    return self;
}

- (instancetype)initWithAcceptorModel:(AcceptorModel *)acceptorModel {
    self = [super init];
    if (self) {
        _acceptorModel = acceptorModel;
    }
    return self;
}

- (instancetype)initWithOrderDetailModel:(OrderModel *)orderDetailModel {
    self = [super init];
    if (self) {
        _orderDetailModel = orderDetailModel;
        [self loadOrderDetailTableDatas];
    }
    return self;
}

- (instancetype)initWithOrderType:(NSInteger)orderType {
    self = [super init];
    if (self) {
        _orderType = orderType;
    }
    return self;
}

- (void)loadOrderDetailTableDatas {
    [self.arrayOrderDetailDatas removeAllObjects];
    if (self.orderDetailModel) {
        if ([self.orderDetailModel.status isEqualToString:@"WAIT"]) {
            //如果是待付款、待收款，开启倒计时
            [self startCountDownWith:self.orderDetailModel.createTimestamp];
        } else if ([self.orderDetailModel.status isEqualToString:@"WAIT_COIN"]) {
            //已付款,开启倒计时
            [self startCountDownWith:self.orderDetailModel.payTimestamp];
        }
        
        FiatOrderDetailTableModel *tableModel0 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"支付方式" subTitle:self.orderDetailModel.payMethodString cellType:FiatOrderDetailCellTypeText];
        
        NSString *tableModel1Title = [self.orderDetailModel.type isEqualToString:@"BUY"] ? @"卖家" : @"买家";
        FiatOrderDetailTableModel *tableModel1 = [[FiatOrderDetailTableModel alloc] initWithTitle:tableModel1Title subTitle:self.orderDetailModel.sellName cellType:FiatOrderDetailCellTypeText];
        
        FiatOrderDetailTableModel *tableModel2 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"收款人" subTitle:self.orderDetailModel.payName cellType:FiatOrderDetailCellTypeText];
        
        FiatOrderDetailTableModel *tableModel3 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"收款账号" subTitle:self.orderDetailModel.payAccount cellType:FiatOrderDetailCellTypeTextAndCopy];
        
        FiatOrderDetailTableModel *tableModel4 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"收款二维码" subTitle:@"" cellType:FiatOrderDetailCellTypeImage];
        
        FiatOrderDetailTableModel *tableModel5 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"订单号" subTitle:self.orderDetailModel.orderNo cellType:FiatOrderDetailCellTypeTextAndCopy];
        
        FiatOrderDetailTableModel *tableModel6 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"参考号" subTitle:self.orderDetailModel.markNo cellType:FiatOrderDetailCellTypeTextAndCopy];
        
        FiatOrderDetailTableModel *tableModel7 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"下单时间" subTitle:self.orderDetailModel.createTime cellType:FiatOrderDetailCellTypeText];
        
        FiatOrderDetailTableModel *tableModel8 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"完成时间" subTitle:self.orderDetailModel.updateTime cellType:FiatOrderDetailCellTypeText];
        
        NSString *tableModel9_subTitle = @"";
        NSString *tableModel10_subTitle = @"";
        if ([self.orderDetailModel.pageType isEqualToString:@"SELL"]) {
            //出售订单-拿卖家内容
            tableModel9_subTitle = [NSString isEmpty:self.orderDetailModel.content1] ? @"" : @"查看";
            tableModel10_subTitle = [NSString isEmpty:tableModel9_subTitle] ? @"" : self.orderDetailModel.atime1;
        } else {
            //购买订单-拿买家内容
            tableModel9_subTitle = [NSString isEmpty:self.orderDetailModel.content] ? @"" : @"查看";
            tableModel10_subTitle = [NSString isEmpty:tableModel9_subTitle] ? @"" : self.orderDetailModel.atime;
        }
                
        FiatOrderDetailCellType cellType9 = [NSString isEmpty:tableModel9_subTitle] ? FiatOrderDetailCellTypeText : FiatOrderDetailCellTypeArrow;
        FiatOrderDetailTableModel *tableModel9 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"我的申诉内容" subTitle:tableModel9_subTitle cellType:cellType9];
                
        FiatOrderDetailTableModel *tableModel10 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"提交时间" subTitle:tableModel10_subTitle cellType:FiatOrderDetailCellTypeText];
        
        NSString *tableModel11_subTitle = @"";
        NSString *tableModel11_title = @"";
        NSString *tableModel12_subTitle = @"";

        if ([self.orderDetailModel.pageType isEqualToString:@"SELL"]) {
            //出售订单
            tableModel11_subTitle = [NSString isEmpty:self.orderDetailModel.content] ? @"" : @"查看";
            tableModel11_title = @"买家";
            tableModel12_subTitle = [NSString isEmpty:tableModel11_subTitle] ? @"" : self.orderDetailModel.atime;
        } else {
            //购买订单
            tableModel11_subTitle = [NSString isEmpty:self.orderDetailModel.content1] ? @"" : @"查看";
            tableModel11_title = @"卖家";
            tableModel12_subTitle = [NSString isEmpty:tableModel11_subTitle] ? @"" : self.orderDetailModel.atime1;
        }
        
        FiatOrderDetailCellType cellType11 = [NSString isEmpty:tableModel11_subTitle] ? FiatOrderDetailCellTypeText : FiatOrderDetailCellTypeArrow;

        FiatOrderDetailTableModel *tableModel11 = [[FiatOrderDetailTableModel alloc] initWithTitle:[NSString stringWithFormat:@"%@%@", tableModel11_title, NSLocalizedString(@"申诉内容", nil)] subTitle:tableModel11_subTitle cellType:cellType11];
        
        FiatOrderDetailTableModel *tableModel12 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"提交时间" subTitle:tableModel12_subTitle cellType:FiatOrderDetailCellTypeText];
        
        FiatOrderDetailTableModel *tableModel13 = [[FiatOrderDetailTableModel alloc] initWithTitle:[NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"银行", nil), self.orderDetailModel.bank] subTitle:[NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"支行", nil), self.orderDetailModel.branch] cellType:FiatOrderDetailCellTypeText];
        
        //限额范围，第一个数字=单笔最低购买(出售)金额，第二个数字=当前剩余数量*单价，单位USD
        CGFloat min = [self.orderDetailModel.lowPrice floatValue];
        CGFloat max = [self.orderDetailModel.restNumber floatValue] * [self.orderDetailModel.unitPrice floatValue]; 
        FiatOrderDetailTableModel *tableModel14 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"限额" subTitle:[NSString stringWithFormat:@"%.2f-%.2f USD", min, max] cellType:FiatOrderDetailCellTypeText];
        
        if ([self.orderDetailModel.status isEqualToString:@"FINISH"]) {
            //已完成
            if ([self.orderDetailModel.payMethod isEqualToString:@"BANK"]) {
                //银行卡
                [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8]];
            } else if ([self.orderDetailModel.payMethod isEqualToString:@"PAYPAL"]) {
                //PALPAL
                [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8]];
            } else {
                //支付宝、微信
                if ([NSString isEmpty:self.orderDetailModel.payImg]) {
                    [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8]];
                } else {
                    [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel4, tableModel5, tableModel6, tableModel7, tableModel8]];
                }
            }
            
        } else if ([self.orderDetailModel.status isEqualToString:@"CANCEL"]) {
            //已取消
            tableModel8 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"取消时间" subTitle:self.orderDetailModel.cancelTime cellType:FiatOrderDetailCellTypeText];
            [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel1, tableModel5, tableModel6, tableModel7, tableModel8]];
            
        } else if ([self.orderDetailModel.status isEqualToString:@"WAIT_COIN"]) {
            //待放币\已付款
            tableModel8 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"付款时间" subTitle:self.orderDetailModel.payTime cellType:FiatOrderDetailCellTypeText];
            
            if ([self.orderDetailModel.payMethod isEqualToString:@"BANK"]) {
                //银行卡
                [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8]];
            } else if ([self.orderDetailModel.payMethod isEqualToString:@"PAYPAL"]) {
                //PALPAL
                [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8]];
            } else {
                //支付宝、微信
                if ([NSString isEmpty:self.orderDetailModel.payImg]) {
                    [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8]];
                } else {
                    [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel4, tableModel5, tableModel6, tableModel7, tableModel8]];
                }
            }
            
        } else if ([self.orderDetailModel.status isEqualToString:@"APPEAL"]) {
            //申诉中
            tableModel8 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"付款时间" subTitle:self.orderDetailModel.payTime cellType:FiatOrderDetailCellTypeText];
            
            if ([self.orderDetailModel.payMethod isEqualToString:@"BANK"]) {
                //银行卡
                [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8, tableModel9, tableModel10, tableModel11, tableModel12]];
            } else if ([self.orderDetailModel.payMethod isEqualToString:@"PAYPAL"]) {
                //PALPAL
                [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8, tableModel9, tableModel10, tableModel11, tableModel12]];
            } else {
                //支付宝、微信
                if ([NSString isEmpty:self.orderDetailModel.payImg]) {
                    [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7, tableModel8, tableModel9, tableModel10, tableModel11, tableModel12]];
                } else {
                    [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel4, tableModel5, tableModel6, tableModel7, tableModel8, tableModel9, tableModel10, tableModel11, tableModel12]];
                }
            }
            
        } else if ([self.orderDetailModel.status isEqualToString:@"WAIT"]) {
            //待付款、待收款
            if ([self.orderDetailModel.payMethod isEqualToString:@"BANK"]) {
                //银行卡
                [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel13, tableModel5, tableModel6, tableModel7]];
            } else if ([self.orderDetailModel.payMethod isEqualToString:@"PAYPAL"]) {
                //PALPAL
                [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7]];
            } else {
                //支付宝、微信
                if ([NSString isEmpty:self.orderDetailModel.payImg]) {
                    [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel5, tableModel6, tableModel7]];
                } else {
                    [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3, tableModel4, tableModel5, tableModel6, tableModel7]];
                }
            }
            
        } else if ([self.orderDetailModel.status isEqualToString:@"Y"]) {
            //挂单中
            tableModel8 = [[FiatOrderDetailTableModel alloc] initWithTitle:@"付款时间" subTitle:self.orderDetailModel.createTime cellType:FiatOrderDetailCellTypeText];
            [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel14, tableModel5, tableModel0, tableModel8]];
            
        } else if ([self.orderDetailModel.status isEqualToString:@"N"]) {
            //已撤单
            [self.arrayOrderDetailDatas addObjectsFromArray:@[tableModel14, tableModel5, tableModel0, tableModel7]];
        }
    }
}

- (void)loadAcceptorTableDatas {
    [self.arrayAcceptorTableDatas removeAllObjects];
    
    if (self.acceptorModel) {
        NSString *margin = @"";
        if ([self.acceptorModel.deposit isEqualToString:@"0"]) {
            margin = @"保证金不足";
        } else if ([self.acceptorModel.deposit isEqualToString:@"6"]) {
            margin = @"承兑商申请审核中";
        }
        
        BaseTableModel *tableModel0 = [[BaseTableModel alloc] initWithTitle:@"我要挂单" subTitle:margin];
        BaseTableModel *tableModel1 = [[BaseTableModel alloc] initWithTitle:@"我的挂单购买"];
        BaseTableModel *tableModel2 = [[BaseTableModel alloc] initWithTitle:@"我的挂单出售"];
        BaseTableModel *tableModel3 = [[BaseTableModel alloc] initWithTitle:@"我的保证金" subTitle:margin];
        [self.arrayAcceptorTableDatas addObjectsFromArray:@[tableModel0, tableModel1, tableModel2, tableModel3]];
    }
}

- (void)loadPaymentMethodTableDatas {
    [self.arrayPaymentTableDatas removeAllObjects];
    if (self.paymentMethodModel) {
        BaseTableModel *tableModel2 = [[BaseTableModel alloc] initWithImageName:@"yhk" title:@"银行卡"];
        tableModel2.content = self.paymentMethodModel.bank;
        [self.arrayPaymentTableDatas addObjectsFromArray:@[tableModel2]];
    }
}

#pragma mark - Request Data
- (void)fetchOrderListWithResult:(RequestMoreResult)result {
    [self.arrayPaymentMethodDatas removeAllObjects];
    
    __block BOOL success = YES;
    __block BOOL loadMore = NO;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    NSDictionary *params = @{@"type" : @(self.orderType),
                             @"coin" : @"USDT",
                             @"payMethod" : self.payMethod,
                             @"price" : self.price,
                             @"number" : self.number,
                             @"current" : @(self.pageNo),
                             @"size" : @(self.pageSize)
    };
    [Service fetchFiatOrderListWithParams:params mapper:[OrderListModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayOrderListDatas removeAllObjects];
            }
            OrderListModel *listModel = responseModel.data;
            NSArray *tempArray = listModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayOrderListDatas addObjectsFromArray:tempArray];
            }
            [self.arrayOrderListDatas enumerateObjectsUsingBlock:^(OrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.orderType = [NSString stringWithFormat:@"%ld", self.orderType];
            }];
            
            loadMore =  [tempArray count] == self.pageSize;
        } else {
            success = NO;
        }
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        dispatch_group_leave(group);
        Logger(@"获取我要购买、我要出售列表失败");
        success = NO;
    }];
    
    dispatch_group_enter(group);
    [Service fetchPaymentMethodWithParams:nil mapper:[PaymentMethodModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            PaymentMethodModel *paymentModel = responseModel.data;
            if (paymentModel.bank && [paymentModel.bank count]) {
                BaseTableModel *tableModel0 = [[BaseTableModel alloc] initWithTitle:@"银行卡"];
                tableModel0.content = paymentModel.bank;
                [self.arrayPaymentMethodDatas addObject:tableModel0];
            }
            if (paymentModel.ali && [paymentModel.ali count]) {
                BaseTableModel *tableModel1 = [[BaseTableModel alloc] initWithTitle:@"支付宝"];
                tableModel1.content = paymentModel.ali;
                [self.arrayPaymentMethodDatas addObject:tableModel1];
            }
            if (paymentModel.payPal && [paymentModel.payPal count]) {
                BaseTableModel *tableModel2 = [[BaseTableModel alloc] initWithTitle:@"PayPal"];
                tableModel2.content = paymentModel.payPal;
                [self.arrayPaymentMethodDatas addObject:tableModel2];
            }
            if (paymentModel.wx && [paymentModel.wx count]) {
                BaseTableModel *tableModel3 = [[BaseTableModel alloc] initWithTitle:@"微信"];
                tableModel3.content = paymentModel.wx;
                [self.arrayPaymentMethodDatas addObject:tableModel3];
            }
        } else {
            success = NO;
        }
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取收款方式失败");
        success = NO;
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        result(success, loadMore);
    });
}

- (void)fetchOrderBuyWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.sellId]) {
        return;
    }
    NSDictionary *params = @{@"sellId" : self.sellId,
                             @"value" : self.value,
                             @"type" : self.buyMethod,
                             @"password" : self.payPwd
    };
    [Service fetchFiatOrderBuyWithParams:params mapper:[OrderModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            OrderModel *orderModel = responseModel.data;
            self.orderNo = orderModel.orderNo;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"下单购买失败");
        result(NO);
    }];
}

- (void)fetchOrderSellWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.buyId]) {
        return;
    }
    NSDictionary *params = @{@"buyId" : self.buyId,
                             @"value" : self.value,
                             @"type" : self.buyMethod,
                             @"paymentId" : self.paymentId,
                             @"payPwd" : self.payPwd
    };
    [Service fetchOrderSellWithParams:params mapper:[OrderModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            OrderModel *orderModel = responseModel.data;
            self.orderNo = orderModel.orderNo;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"下单出售失败");
        result(NO);
    }];
}

- (void)fetchOrderInfoWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.orderNo]) {
        return;
    }
    NSDictionary *params = @{@"orderNo" : self.orderNo};
    [Service fetchFiatOrderInfoWithParams:params mapper:[OrderModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.orderDetailModel = responseModel.data;
            self.orderDetailModel.pageType = self.pageType;
            [self loadOrderDetailTableDatas];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取法币交易-订单页面信息失败");
        result(NO);
    }];
}

- (void)fetchOrderCancelTipWithResult:(RequestMsgResult)result {
    if ([NSString isEmpty:self.orderNo]) {
        return;
    }
    NSDictionary *params = @{@"orderNo" : self.orderNo};
    [Service fetchFiatOrderCancelTipWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if ([responseModel.code isEqualToString:@"200"]) {
                result(YES, responseModel.msg);
            } else {
                result(NO, responseModel.msg);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取取消订单提示失败");
        result(NO, @"");
    }];
}

- (void)fetchOrderCancelWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.orderNo]) {
        return;
    }
    NSDictionary *params = @{@"orderNo" : self.orderNo};
    [Service fetchFiatOrderCancelWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"取消订单失败");
        result(NO);
    }];
}

- (void)fetchMineOrderListWithResult:(RequestMoreResult)result {
    NSString *pageType = self.orderType == 0 ? @"BUY" : @"SELL";
    NSString *status = @"";
    if (self.orderStatus == FiatOrderStatusFinish) {
        //已完成
        status = @"FINISH";
    } else if (self.orderStatus == FiatOrderStatusWaitPayment || self.orderStatus == FiatOrderStatusPendingPayment) {
        //待付款、待收款
        status = @"WAIT";
    } else if (self.orderStatus == FiatOrderStatusPaid || self.orderStatus == FiatOrderStatusWaitPutMoney) {
        //待放币、已付款
        status = @"WAIT_COIN";
    } else if (self.orderStatus == FiatOrderStatusCancelled) {
        //已取消
        status = @"CANCEL";
    } else if (self.orderStatus == FiatOrderStatusAppealing) {
        //申诉中
        status = @"APPEAL";
    }
    NSDictionary *params = @{@"pageType" : pageType,
                             @"status" : status,
                             @"current" : @(self.pageNo),
                             @"size" : @(self.pageSize)
    };
    [Service fetchMineOrderListWithParams:params mapper:[OrderListModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayMineOrderListDatas removeAllObjects];
            }
            OrderListModel *listModel = responseModel.data;
            NSArray *tempArray = listModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayMineOrderListDatas addObjectsFromArray:tempArray];
            }
            [self.arrayMineOrderListDatas enumerateObjectsUsingBlock:^(OrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.pageType = pageType;
            }];
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取我的订单失败");
        result(NO, NO);
    }];
}

- (void)fetchOrderFinishPayWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.orderNo]) {
        return;
    }
    NSDictionary *params = @{@"orderNo" : self.orderNo};
    [Service fetchOrderFinishPayWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取已完成付款失败");
        result(NO);
    }];
}

- (void)fetchUploadImage:(UIImage *)img result:(RequestResult)result {
    NSArray *imageArray = @[img];
    [Service uploadImageWithParams:nil imageArray:imageArray mapper:[ImageModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            ImageModel *imgModel = responseModel.data;
            [self.arrayImageUrls addObject:imgModel.src];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"上传图片失败");
        result(NO);
    }];
}

- (void)fetchSubmitAppealWithResult:(RequestResult)result {
    if ([NSString isEmpty:self.orderNo]) {
        return;
    }
    NSDictionary *params = @{@"orderNo" : self.orderNo,
                             @"content" : self.content,
                             @"img" : self.imgUrls
    };
    [Service fetchSubmitAppealWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"申诉失败");
        result(NO);
    }];
}

- (void)fetchAcceptorMarginInfoWithResult:(RequestResult)result {
    [Service fetchAcceptorMarginInfoWithParams:nil mapper:[AcceptorModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.acceptorModel = responseModel.data;
            [self loadAcceptorTableDatas];
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取承兑商保证金信息失败");
        result(NO);
    }];
}

- (void)fetchApplyToBecomeAnAcceptorWithResult:(RequestResult)result {
    NSDictionary *params = @{@"type" : @"USDT",
                             @"payPwd" : self.payPwd
    };
    [Service fetchApplyToBecomeAnAcceptorWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"申请承兑商失败");
        result(NO);
    }];
}

- (void)fetchPendingOrderPurchaseWithResult:(RequestResult)result {
    NSString *payMethod = @"PAYPAL";
    if ([self.payMethod isEqualToString:@"支付宝"]) {
        payMethod = @"ALI_PAY";
    } else if ([self.payMethod isEqualToString:@"微信"]) {
        payMethod = @"WE_CHAT";
    } else if ([self.payMethod isEqualToString:@"银行卡"]) {
        payMethod = @"BANK";
    }
    NSDictionary *params = @{@"coin" : @"USDT",
                             @"unitPrice" : self.price,
                             @"number" : self.number,
                             @"lowNumber" : self.lowNumber,
                             @"lowPrice" : self.lowPrice,
                             @"payMethod" : payMethod
    };
    [Service fetchPendingOrderPurchaseWithParams:params mapper:[OrderModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.orderDetailModel = responseModel.data;
            self.orderDetailModel.pageType = @"BUY";
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"挂单购买失败");
        result(NO);
    }];
}

- (void)fetchMinePendingOrderListWithResult:(RequestMoreResult)result {
    NSString *pageType = self.orderType == 0 ? @"BUY" : @"SELL";
    NSDictionary *params = @{@"pageType" : pageType,
                             @"size" : @(self.pageSize),
                             @"current" : @(self.pageNo)
    };
    [Service fetchMinePendingOrderListWithParams:params mapper:[OrderListModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            if (self.pageNo == 1) {
                [self.arrayOrderListDatas removeAllObjects];
            }
            OrderListModel *listModel = responseModel.data;
            NSArray *tempArray = listModel.records;
            if (tempArray && [tempArray count]) {
                [self.arrayOrderListDatas addObjectsFromArray:tempArray];
            }
            [self.arrayOrderListDatas enumerateObjectsUsingBlock:^(OrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.pageType = pageType;
            }];
            result(YES, [tempArray count] == self.pageSize);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取我的订单（挂单购买、出售订单）失败");
        result(NO, NO);
    }];
}

- (void)fetchCancelPendingOrderWithResult:(RequestResult)result {
    NSDictionary *params = @{@"pageType" : self.orderDetailModel.pageType,
                             @"orderNo" : self.orderDetailModel.orderNo
    };
    [Service fetchMinePendingOrderCancelWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"挂单中-撤单失败");
        result(NO);
    }];
}

- (void)fetchPendingOrderSellInfoWithResult:(RequestResult)result {
    __block BOOL success = YES;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    NSDictionary *params = @{@"type" : @"USDT"};
    [Service fetchMinePendingOrderSellInfoWithParams:params mapper:[OrderModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.orderDetailModel = responseModel.data;
        } else {
            success = NO;
        }
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        Logger(@"我要挂单-挂单出售页面信息获取失败");
        dispatch_group_leave(group);
        success = NO;
    }];
    
    dispatch_group_enter(group);
    [Service fetchPaymentMethodWithParams:nil mapper:[PaymentMethodModel class] showHUD:YES success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.paymentMethodModel = responseModel.data;
        } else {
            success = NO;
        }
        dispatch_group_leave(group);
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取收款方式错误");
        dispatch_group_leave(group);
        success = NO;
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self loadPaymentMethodTableDatas];
        result(success);
    });
}

- (void)fetchPendingOrderSellWithResult:(RequestResult)result {
    NSDictionary *params = @{@"coin" : @"USDT",
                             @"unitPrice" : self.price,
                             @"number" : self.number,
                             @"lowNumber" : self.lowNumber,
                             @"lowPrice" : self.lowPrice,
                             @"payMethod" : self.payMethod,
                             @"paymentId" : self.paymentId
    };
    [Service fetchPendingOrderSellWithParams:params mapper:[OrderModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.orderDetailModel = responseModel.data;
            self.orderDetailModel.pageType = @"SELL";
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"挂单出售失败");
        result(NO);
    }];
}

- (void)fetchRefundDepositWithResult:(RequestResult)result {
    [Service fetchRefundDepositWithParams:nil mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"退还保证金失败");
        result(NO);
    }];
}

- (void)fetchPutMoneyWithPassword:(NSString *)password result:(RequestResult)result {
    NSDictionary *params = @{@"payPwd" : password,
                             @"orderNo" : self.orderNo
    };
    [Service fetchPutMoneyWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"放币失败");
        result(NO);
    }];
}

- (void)fetchMakeUpDepositWithResult:(RequestResult)result {
    [Service fetchMakeUpDepositWithParams:nil mapper:[AcceptorModel class] showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            self.acceptorModel = responseModel.data;
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"获取补缴页面信息失败");
        result(NO);
    }];
}

- (void)fetchSubmitDepositWithPassword:(NSString *)password result:(RequestResult)result {
    NSDictionary *params = @{@"payPwd" : password};
    [Service fetchSubmitDepositWithParams:params mapper:nil showHUD:self.showHUD success:^(BaseResponseModel * _Nonnull responseModel) {
        if (responseModel.data) {
            result(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        Logger(@"提交补缴失败");
        result(NO);
    }];
}

#pragma mark - 倒计时
- (void)startCountDownWith:(NSString *)time {
    NSTimeInterval delta = [time doubleValue] / 1000;
        
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];

        NSTimeInterval countdownTime = currentTime - delta; // 从开始倒计时已过去的时间
        
        NSInteger retainTime = kPayCountdownSecond - countdownTime;
        
        NSString *timeString = [self getTimeString:retainTime];
        
        if (retainTime > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.onUpdatePayCountDownBlock) {
                    self.onUpdatePayCountDownBlock(timeString, NO);
                }
            });
            
        } else {
            //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.onUpdatePayCountDownBlock) {
                    self.onUpdatePayCountDownBlock(timeString, YES);
                }
            });
        }
        
    });
    dispatch_resume(_timer);
}

- (NSString *)getTimeString:(NSInteger)time {
    NSInteger min = 0;
    NSInteger sec = 0;
    
    if (time > 0) {
        sec = time % 60;
        
        min = time / 60;
    }
    
    return [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
}

- (void)stopCountDown {
    // 停止倒计时
    if ([self.orderDetailModel.status isEqualToString:@"WAIT"]) {
        if (_timer) {
            dispatch_source_cancel(_timer);
        }
    }
}

#pragma mark - Setter & Getter
- (NSMutableArray<FiatOrderDetailTableModel *> *)arrayOrderDetailDatas {
    if (!_arrayOrderDetailDatas) {
        _arrayOrderDetailDatas = [NSMutableArray arrayWithCapacity:13];
    }
    return _arrayOrderDetailDatas;
}

- (NSMutableArray<BaseTableModel *> *)arrayAcceptorTableDatas {
    if (!_arrayAcceptorTableDatas) {
        _arrayAcceptorTableDatas = [NSMutableArray arrayWithCapacity:4];
    }
    return _arrayAcceptorTableDatas;
}

- (NSMutableArray<BaseTableModel *> *)arrayPaymentTableDatas {
    if (!_arrayPaymentTableDatas) {
        _arrayPaymentTableDatas = [NSMutableArray arrayWithCapacity:4];
    }
    return _arrayPaymentTableDatas;
}

- (NSMutableArray<OrderModel *> *)arrayOrderListDatas {
    if (!_arrayOrderListDatas) {
        _arrayOrderListDatas = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayOrderListDatas;
}

- (NSMutableArray<OrderModel *> *)arrayMineOrderListDatas {
    if (!_arrayMineOrderListDatas) {
        _arrayMineOrderListDatas = [NSMutableArray arrayWithCapacity:10];
    }
    return _arrayMineOrderListDatas;
}

- (NSMutableArray<NSString *> *)arrayImageUrls {
    if (!_arrayImageUrls) {
        _arrayImageUrls = [NSMutableArray arrayWithCapacity:3];
    }
    return _arrayImageUrls;
}

- (NSMutableArray<BaseTableModel *> *)arrayPaymentMethodDatas {
    if (!_arrayPaymentMethodDatas) {
        _arrayPaymentMethodDatas = [NSMutableArray arrayWithCapacity:4];
    }
    return _arrayPaymentMethodDatas;
}

@end
