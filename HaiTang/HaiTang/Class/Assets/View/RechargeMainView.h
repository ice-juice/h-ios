//
//  RechargeMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RechargeMainViewDelegate <BaseMainViewDelegate>
//选择币种
- (void)mainViewWithSelectSymbol:(NSString *)symbol;
//充币地址信息
- (void)viewWithRechargeAddress;
//选择图片
- (void)viewWithSelectImages;
//提交充币
- (void)viewWithSubmitRecharge;

@end

@interface RechargeMainView : BaseMainView
- (void)updateLinkBtnView;
- (void)updateImages;

@end

NS_ASSUME_NONNULL_END
