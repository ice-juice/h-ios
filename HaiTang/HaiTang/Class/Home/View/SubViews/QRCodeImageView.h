//
//  QRCodeImageView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/12/8.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeImageView : BaseView
- (void)showView:(NSString *)imgUrl;
- (void)closeView;

@end

NS_ASSUME_NONNULL_END
