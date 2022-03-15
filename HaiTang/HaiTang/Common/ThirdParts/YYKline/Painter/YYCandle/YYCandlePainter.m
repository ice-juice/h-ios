//
//  YYCandlePainter.m
//  YYKline
//
//  Copyright © 2019 WillkYang. All rights reserved.
//

#import "YYCandlePainter.h"
#import "YYKlineGlobalVariable.h"
#import "UIColor+YYKline.h"

@implementation YYCandlePainter

+ (YYMinMaxModel *)getMinMaxValue:(NSArray <YYKlineModel *> *)data {
    if(!data) {
        return [YYMinMaxModel new];
    }
    __block CGFloat minAssert = data[0].low.floatValue;
    __block CGFloat maxAssert = data[0].high.floatValue;
    [data enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, m.high.floatValue);
        minAssert = MIN(minAssert, m.low.floatValue);
    }];
    return [YYMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <YYKlineModel *> *)models minMax: (YYMinMaxModel *)minMaxModel {
    if(!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;

    YYCandlePainter *sublayer = [[YYCandlePainter alloc] init];
    sublayer.frame = area;
    sublayer.contentsScale = UIScreen.mainScreen.scale;
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {        
        CGFloat w = [YYKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        CGFloat centerX = x+w/2.f-[YYKlineGlobalVariable kLineGap]/2.f;
        CGPoint highPoint = CGPointMake(centerX, maxH - (m.high.floatValue - minMaxModel.min)*unitValue);
        CGPoint lowPoint = CGPointMake(centerX, maxH - (m.low.floatValue - minMaxModel.min)*unitValue);

        // 开收
        CGFloat h = fabsf(m.open.floatValue - m.close.floatValue) * unitValue;
        CGFloat y =  maxH - (MAX(m.open.floatValue, m.close.floatValue) - minMaxModel.min) * unitValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w - [YYKlineGlobalVariable kLineGap], h)];
        
        [path moveToPoint:lowPoint];
        [path addLineToPoint:CGPointMake(centerX, y+h)];
        [path moveToPoint:highPoint];
        [path addLineToPoint:CGPointMake(centerX, y)];
        
        
        CAShapeLayer *l = [CAShapeLayer layer];
        l.contentsScale = UIScreen.mainScreen.scale;
        l.path = path.CGPath;
        l.lineWidth = YYKlineLineWidth;
        
        l.strokeColor = m.isUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        //2020-11-13 [uiColor clearColor]
        l.fillColor =   m.isUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        [sublayer addSublayer:l];
    }];
    [layer addSublayer:sublayer];
}

@end
