//
//  CIImage+ZYCategory.m
//  GoldenHShield
//
//  Created by 吴紫颖 on 2020/6/5.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "CIImage+ZYCategory.h"

@implementation CIImage (ZYCategory)
/**
 *  根据CIImage生成指定大小的UIImage
 *  @param size CIImage 图片宽度
*/

- (UIImage*)createNonInterpolatedWithSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(self.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width =CGRectGetWidth(extent) * scale;
    size_t height =CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:self fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];

}

@end
