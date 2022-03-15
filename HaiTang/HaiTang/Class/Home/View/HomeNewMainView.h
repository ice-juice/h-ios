//
//  HomeNewMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2021/2/2.
//  Copyright © 2021 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HomeNewMainViewDelegate <BaseMainViewDelegate>
//公告平台
- (void)viewWithCheckNotice;
//帮助中心
- (void)viewWithCheckHelpCenter;
//法币
- (void)viewWithCheckFiat;
//充币
- (void)viewWithCheckRecharge;
//提币
- (void)viewWithCheckWithdraw;
//邀请好友
- (void)viewWithCheckInviteFriend;
//查看合约或币币行情
- (void)viewWithCheckContractOrCoin;
//查看k线(合约永续)
- (void)viewWithCheckContractKline:(NSString *)symbol;
//查看k线（合约、币币）
- (void)viewWithCheckKline:(NSString *)symbol;
//查看轮播图
- (void)viewWithSelectBanner:(NSString *)link;
//查看公告详情
- (void)viewWithCheckNoticeDetail:(NSString *)index;

- (void)viewWithScrollView:(UIScrollView *)scrollView;

@end

@interface HomeNewMainView : BaseMainView
//更新头部视图
- (void)updateHeaderView;
//更新合约
- (void)updateContractView;

@end

NS_ASSUME_NONNULL_END
