//
//  AssetsMainViewModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class BaseTableModel, AssetsModel, AddressModel, SymbolModel, UserModel;

@interface AssetsMainViewModel : BaseMainViewModel
{
    dispatch_source_t _timer;
}
//USDT资产类型
@property (nonatomic, assign) USDTAssetsType usdtAssetsType;
//资产账户id
@property (nonatomic, copy) NSString *list_id;
//币种（默认usdt）
@property (nonatomic, copy) NSString *symbol;
//地址、区块链交易ID
@property (nonatomic, copy) NSString *toAddress;
//提币数量、充值金额
@property (nonatomic, copy) NSString *price;
//资产密码
@property (nonatomic, copy) NSString *payPwd;
//Memo值或tag值
@property (nonatomic, copy) NSString *memoOrTagValue;
//短信验证码
@property (nonatomic, copy) NSString *smsCode;
//账号
@property (nonatomic, copy) NSString *account;
//邮箱验证码
@property (nonatomic, copy) NSString *emailCode;
//划出账户（默认钱包账户）
@property (nonatomic, copy) NSString *from;
//划入账户（默认币币账户）
@property (nonatomic, copy) NSString *to;
//类型 充币-CHANGER，其他为空
@property (nonatomic, copy) NSString *type;
//充币凭证，以逗号分隔
@property (nonatomic, copy) NSString *remark;

//个人资产信息
@property (nonatomic, strong) AssetsModel *assetsModel;
//资产详情
@property (nonatomic, strong) AssetsModel *assetsDetailModel;
//充币地址
@property (nonatomic, strong) AddressModel *rechargeAddressModel;
//提币页面信息
@property (nonatomic, strong) AssetsModel *withdrawInfoModel;
//用户信息
@property (nonatomic, strong) UserModel *userModel;
//资产划转页面信息
@property (nonatomic, strong) AssetsModel *transferInfoModel;

//全部币种列表
@property (nonatomic, strong) NSArray<SymbolModel *> *arraySymbolDatas;
@property (nonatomic, strong) NSMutableArray<NSString *> *arrayImageDatas;
@property (nonatomic, strong) NSMutableArray<BaseTableModel *> *arrayUSDTAssetsTableDatas;


- (instancetype)initWithSymbol:(NSString *)symbol;
- (instancetype)initWithSymbol:(NSString *)symbol type:(NSString *)type;
- (instancetype)initWithUSDTAssetsType:(USDTAssetsType)usdtAssetsType list_id:(NSString *)list_id;

- (void)loadUSDTAssetsTableDatas;

//个人资产信息
- (void)fetchAssetsInfoWithResult:(RequestResult)result;
//资产详情
- (void)fetchAssetsDetailWithResult:(RequestResult)result;
//充币地址
- (void)fetchRechargeAddressWithResult:(RequestResult)result;
//全部币种列表
- (void)fetchSymbolListWithResult:(RequestResult)result;
//提币页面信息
- (void)fetchWithdrawInfoWithResult:(RequestResult)result;
//获取验证码
- (void)sendVerifyCodeCountDown:(void(^)(NSString *countDown, BOOL isEnd))block result:(RequestResult)result;
//停止倒计时
- (void)stopCountDown;
//提币
- (void)fetchSubmitWithdrawWithResult:(RequestResult)result;
//资产划转页面信息
- (void)fetchTransferInfoWithResult:(RequestResult)result;
//资产划转
- (void)fetchSubmitTransferWith:(NSString *)number result:(RequestResult)result;
//用户信息
- (void)fetchUserInfoDataWithResult:(RequestResult)result;
//上传图片文件
- (void)uploadPhotoFilesWith:(NSArray<UIImage *> *)images withResult:(RequestResult)result;
//提交充币
- (void)fetchSubmitRechargeWithResult:(RequestResult)result;

@end

NS_ASSUME_NONNULL_END
