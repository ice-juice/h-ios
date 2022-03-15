//
//  CIImage+ZYCategory.h
//  GoldenHShield
//
//  Created by 吴紫颖 on 2020/6/5.
//  Copyright © 2020 吴紫颖. All rights reserved.
//  根据链接生成二维码
#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIImage (ZYCategory)
/**

 根据CIImage生成指定大小的UIImage

 @param size 尺寸

 @return 图片对象

 */
- (UIImage *)createNonInterpolatedWithSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
