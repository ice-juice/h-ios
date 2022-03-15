//
//  UploadPhotosMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UploadPhotosMainViewDelegate <BaseMainViewDelegate>
//上传证件带头像面照片
- (void)mainViewWithUploadPortrait;
//上传本人手持证件带头像面照片
- (void)mainViewWithUploadNationalEmblem;
//实名认证
- (void)mainViewWithRealVerify;

@end

@interface UploadPhotosMainView : BaseMainView
//更新选中图片
- (void)updateImageView;

@end

NS_ASSUME_NONNULL_END
