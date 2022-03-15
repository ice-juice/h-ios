//
//  UserModel.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/20.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : BaseModel
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *account;        //账号
@property (nonatomic, copy) NSString *email;          //邮箱
@property (nonatomic, copy) NSString *inviteCode;     //邀请码
@property (nonatomic, copy) NSString *inviteLink;     //邀请链接
@property (nonatomic, copy) NSString *phone;          //电话
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *realStatus;     //是否实名认证 0-未认证 1-已认证 2-审核中
@property (nonatomic, copy) NSString *isOpenPay;      //是否开启资产密码 Y:是 N:否
@property (nonatomic, copy) NSString *paySmsType;     //资产密码验证码方式 PHONE-手机验证 EMAIL-邮箱验证 通过账号进行发送短信或邮箱验证
@property (nonatomic, copy) NSString *nickName;       //法币交易昵称
@property (nonatomic, copy) NSString *realName;       //真实姓名，用于法币收款方式设置那里显示
@property (nonatomic, copy) NSString *contactPhone;   //客服，外链接
@property (nonatomic, copy) NSString *loginMethod;    //PHONE-手机 EMAIL-邮箱

@end

NS_ASSUME_NONNULL_END
