//
//  HomeMainViewModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HomeTableModel,
       BaseTableModel,
       NewModel,
       BannerModel,
       UserModel,
       DataModel,
       QuotesModel,
       PaymentTableModel;

@interface HomeMainViewModel : BaseMainViewModel
{
    dispatch_source_t _timer;
}
//用户信息
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) DataModel *dataModel;

//轮播图列表
@property (nonatomic, strong) NSArray<BannerModel *> *arrayBannerDatas;
//首页币种行情
@property (nonatomic, strong) NSArray<QuotesModel *> *arrayQuotesDatas;
//合约行情
@property (nonatomic, strong) NSArray<QuotesModel *> *arrayContractPrices;
//公告列表
@property (nonatomic, strong) NSMutableArray<NewModel *> *arrayNewDatas;
//收款方式
@property (nonatomic, strong) NSMutableArray<NewModel *> *arrayCollectionDatas;
@property (nonatomic, strong) NSMutableArray<HomeTableModel *> *arrayTableDatas;
@property (nonatomic, strong) NSMutableArray<NSArray *> *arrayPersonalTableDatas;
@property (nonatomic, strong) NSMutableArray<NSArray *> *arraySecurityTableDatas;
@property (nonatomic, strong) NSMutableArray<PaymentTableModel *> *arrayPaymentTableDatas;

//绑定类型
@property (nonatomic, assign) BindType bindType;
//添加收款方式
@property (nonatomic, assign) AddPaymentType addPaymentType;
//修改类型
@property (nonatomic, assign) ModifyType modifyType;
//新密码
@property (nonatomic, copy) NSString *password;
//账号
@property (nonatomic, copy) NSString *account;
//身份证号
@property (nonatomic, copy) NSString *idCard;
//姓
@property (nonatomic, copy) NSString *fistName;
//名
@property (nonatomic, copy) NSString *lastName;
//证件类型
@property (nonatomic, copy) NSString *cardType;
//证件带头像面照片(收款二维码照片)
@property (nonatomic, copy) NSString *frontImg;
//本人手持证件带头像面照片
@property (nonatomic, copy) NSString *backImg;
//行情类型 0-币币 1-永续合约(默认永续合约)
@property (nonatomic, copy) NSString *quotesType;
//手机区号
@property (nonatomic, copy) NSString *code;
//客服外链
@property (nonatomic, copy) NSString *serviceString;
//首页scrollView高度
@property (nonatomic, assign) CGFloat scrollViewHeight;
//首页行情高度
@property (nonatomic, assign) CGFloat homeQuotesHeight;

- (instancetype)initWithBindType:(BindType)bindType;
- (instancetype)initWithModifyType:(NSInteger)modifyType;
- (instancetype)initWithAddPaymentType:(AddPaymentType)addPaymentType;

- (void)loadPaymentTableDatas;
- (void)loadSecurityTableDatas;

//获取上次缓存数据
- (BOOL)hasCacheData;

//获取首页信息
- (void)fetchHomeInfoWithResult:(RequestResult)result;
//平台公告列表
- (void)fetchNoticeListWithResult:(RequestMoreResult)result;
//帮助中心
- (void)fetchHelpListWithResult:(RequestMoreResult)result;
//用户信息
- (void)fetchUserInfoWithResult:(RequestResult)result;
//邀请好友
- (void)fetchInviteFriendsInfoWithResult:(RequestResult)result;
//修改登录密码或资产密码
- (void)fetchUpdatePassword:(NSString *)msgOrOldPassword result:(RequestResult)result;
//获取验证码
- (void)sendVerifyCodeCountDown:(void(^)(NSString *countDown, BOOL isEnd))block result:(RequestResult)result;
//停止倒计时
- (void)stopCountDown;
//设置昵称
- (void)fetchNickName:(NSString *)nickName result:(RequestResult)result;
//检查验证码是否正确
- (void)fetchVerificationCode:(NSString *)verifyCode result:(RequestResult)result;
//账号绑定
- (void)fetchBindingAccount:(NSString *)verifyCode result:(RequestResult)result;
//退出登录
- (void)fetchLogoutWithResult:(RequestResult)result;
//收款方式列表
- (void)fetchCollectionSettingsWithResult:(RequestMoreResult)result;
//上传身份证照片
- (void)fetchUploadIDCardPicture:(UIImage *)image isPositive:(BOOL)isPositive result:(RequestResult)result;
//实名认证
- (void)fetchRealNameVerifyWithResult:(RequestResult)result;
//添加收款方式
- (void)fetchAddPayment:(NSString *)name address:(NSString *)address result:(RequestResult)result;
//删除收款方式
- (void)fetchDeletePayment:(NSString *)paymentId result:(RequestResult)result;
//获取币种行情
- (void)fetchQuotesWithResult:(RequestResult)result;
//获取联系客服信息
- (void)fetchServiceWithResult:(RequestResult)result;
//获取合约行情
- (void)fetchContractPricesWithResult:(RequestResult)result;

@end

NS_ASSUME_NONNULL_END
