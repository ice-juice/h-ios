//
//  TransferMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TransferMainViewDelegate <BaseMainViewDelegate>
//选择币种
- (void)mainViewWithSelectSymbol:(NSString *)symbol;
//获取划转页面信息
- (void)mainViewWithTransferInfo;
//资产划转
- (void)mainViewWithSubmitTransfer:(NSString *)number;

@end

@interface TransferMainView : BaseMainView

@end

NS_ASSUME_NONNULL_END
