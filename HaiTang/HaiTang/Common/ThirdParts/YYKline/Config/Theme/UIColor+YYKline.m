//
//  UIColor+YYKline.m
//  YYKline
//
//  Copyright © 2016年 WillkYang. All rights reserved.
//

#import "UIColor+YYKline.h"

@implementation UIColor (YYKline)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark 所有图表的背景颜色
+ (UIColor *)backgroundColor {
    return [UIColor colorWithRGBHex:0x030E1E];
}

#pragma mark 辅助背景色
+ (UIColor *)assistBackgroundColor {
    return [UIColor colorWithRGBHex:0x030E1E];
}

#pragma mark 涨的颜色
+ (UIColor *)upColor {
    //2020-12-01
    return [UIColor colorWithRGBHex:0x00b07c];
}

#pragma mark 跌的颜色
+ (UIColor *)downColor {
    //2020-12-01
    return [UIColor colorWithRGBHex:0xff5353];
}

#pragma mark 主文字颜色
+ (UIColor *)mainTextColor {
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark 分时线的颜色
+ (UIColor *)timeLineLineColor {
    return [UIColor colorWithRGBHex:0xff1aa3f0];
}

#pragma mark 长按时线的颜色
+ (UIColor *)longPressLineColor {
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

+ (UIColor *)line1Color {
    return [UIColor colorWithRGBHex:0xff783c];
//    return [UIColor purpleColor];
}

+ (UIColor *)line2Color {
    return [UIColor colorWithRGBHex:0x49a5ff];
//    return [UIColor greenColor];
}

+ (UIColor *)line3Color {
    return [UIColor purpleColor];
}
@end
