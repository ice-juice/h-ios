//
//  UIImage+Category.h
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)
/** 把颜色转换为图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 返回一张可以随意拉伸不变形的图片 */
+ (UIImage *)resizableImage:(NSString *)imageName;

/** 从一个控件中截取指定大小的图片 */
+ (UIImage *)imageFromView :(UIView *)view size:(CGSize)size;

/** 从图片中按指定的位置大小截取图片的一部分 */
+ (UIImage *)cutImageFromImage:(UIImage *)image inRect:(CGRect)rect;

/** 生成二维码 */
+ (UIImage *)createQRCodeImageWithString:(NSString *)string size:(CGSize)size;

/** 生成条形码 */
+ (instancetype)createBarCodeImageWithString:(NSString *)string size:(CGSize)size;

/** 图片以指定的宽度缩放 */
- (UIImage *)scaleToWidth:(CGFloat)width;

/** 图片以指定的高度缩放 */
- (UIImage *)scaleToHeight:(CGFloat)height;

/** 长方形截成正方形 */
- (UIImage *)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect
             centerBool:(BOOL)centerBool;

@end

NS_ASSUME_NONNULL_END
