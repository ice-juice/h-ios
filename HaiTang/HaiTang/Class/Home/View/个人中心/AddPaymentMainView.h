//
//  AddPaymentMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/15.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddPaymentMainViewDelegate <BaseMainViewDelegate>
//上传收款二维码
- (void)mainViewWithUploadQRCode;
//添加收款方式
- (void)mainViewWithAddPayment:(NSString *)bankName address:(NSString *)address;

@end

@interface AddPaymentMainView : BaseMainView
- (void)updateImageView;

@end

NS_ASSUME_NONNULL_END
