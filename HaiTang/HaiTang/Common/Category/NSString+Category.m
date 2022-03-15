//
//  NSString+Category.m
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
/**
 *  判断字符串是否为空
 *  @return  YES:为空，NO:不为空
 */
+ (BOOL)isEmpty:(NSString *)str {
    if (!str ||
        !str.length ||
        ![str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length ||
        [str isKindOfClass:[NSNull class]] ||
        [str isEqualToString:@"<null>"] ||
        [str isEqualToString:@"(null)"] ||
        [str isEqualToString:@"null"] ||
        [str isEqualToString:@"nil"]) {
        return YES;
    }

    return NO;
}

- (NSAttributedString *)attributedStringWithSubString:(NSString *)subString subColor:(UIColor *)color {
    if (subString && color) {
        return [self attributedStringWithSubStrings:[NSArray arrayWithObject:subString] subColors:[NSArray arrayWithObject:color]];
    }
    
    return [[NSMutableAttributedString alloc] initWithString:self];
;
}

- (NSAttributedString *)attributedStringWithSubStrings:(NSArray<NSString *> *)subStrings subColors:(NSArray<UIColor *> *)colors {
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] initWithString:self];
    if (self.length) {
        [subStrings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length && (idx < [colors count])) {
                NSRange range = [self rangeOfString:obj];
                if (range.location != NSNotFound) {
                    [resultAttributedString addAttribute:NSForegroundColorAttributeName value:colors[idx] range:range];
                }
            }
        }];
    }
    
    return resultAttributedString;
}

- (NSAttributedString *)attributedStringWithSubString:(NSString *)subString subFont:(UIFont *)font {
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] initWithString:self];
    if (self.length && subString && subString.length) {
        NSRange range = [self rangeOfString:subString];
        if (range.location != NSNotFound) {
            [resultAttributedString addAttribute:NSFontAttributeName value:font range:range];
        }
    }
    
    return resultAttributedString;
}

- (NSAttributedString *)attributedStringWithSubString:(NSString *)subString subColor:(UIColor *)color subFont:(UIFont *)font {
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] initWithString:self];
    if (self.length && subString && subString.length) {
        NSRange range = [self rangeOfString:subString];
        if (range.location != NSNotFound) {
            [resultAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
            [resultAttributedString addAttribute:NSFontAttributeName value:font range:range];
        }
    }
    
    return resultAttributedString;
}

// NSStrikethroughColorAttributeName
- (NSAttributedString *)attributedStringWithLineColor:(UIColor *)color {
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] initWithString:self];
    if (self.length) {
        NSRange range = [self rangeOfString:self];
        if (range.location != NSNotFound) {
            [resultAttributedString addAttribute:NSStrikethroughColorAttributeName value:color range:range];
            [resultAttributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        }
    }
    
    return resultAttributedString;
}

/** 获取自适应高度 */
- (CGFloat)heightForFont:(UIFont *)font maxWidth:(CGFloat)width {
    CGFloat height = 0;
    
    if (self.length) {
        NSDictionary *attributes = @{ NSFontAttributeName : font };
        height = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    }
    
    return height;
}

/** 获取自适应宽度 */
- (CGFloat)widthForFont:(UIFont *)font maxHeight:(CGFloat)height {
    CGFloat width = 0;
    
    if (self.length) {
        NSDictionary *attributes = @{ NSFontAttributeName : font };
        width = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    }
    
    return width;
}

- (NSString *)stringByAppendingNameScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    return [self stringByAppendingFormat:@"@%@x", @(scale)];
}

- (NSString *)stringByAppendingPathScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

- (CGFloat)pathScale {
    if (self.length == 0 || [self hasSuffix:@"/"]) return 1;
    NSString *name = self.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    [name enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
        scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
    }];
    return scale;
}

- (void)enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (BOOL)isNumber {
    BOOL result = NO;
    
    if (self.length > 0) {
        if([self isPureInt] || [self isPureFloat]) {
            result = YES;
        }
    }
    
    return result;
}

/** 判断是否为整形 */
- (BOOL)isPureInt
{
    int val;
    NSScanner *scan = [NSScanner scannerWithString:self];
    return [scan scanInt:&val] && [scan isAtEnd];
}

/** 判断是否为浮点形 */
- (BOOL)isPureFloat
{
    float val;
    NSScanner *scan = [NSScanner scannerWithString:self];
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/** 判断字符串是否同时包含数字和字符，并且在最小和最大长度范围内 */
- (BOOL)isValidAlphanumericWithMinLength:(NSInteger)minLength maxLength:(NSInteger)maxLength
{
    BOOL result = NO;
    NSString * regex = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{%ld,%ld}$", minLength, maxLength];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}

+ (NSString *)removeTheLastOneStr:(NSString *)string {
    if([string length] > 0){
        return  [string substringToIndex:([string length] - 1)];//去掉最后一个字符串如", ."
    }else{
        return string;
    }
}

- (BOOL)isValidEmail
{
    NSPredicate *postcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"];
    return [postcodeTest evaluateWithObject:self];
}

- (BOOL)isNickName {
    NSPredicate *postcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\u4E00-\u9FA5A-Za-z0-9]{4,20}$"];
    return [postcodeTest evaluateWithObject:self];
}

- (BOOL)isStrongPassword {
    NSPredicate *postcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[a-zA-Z0-9]{8,30}$"];
    return [postcodeTest evaluateWithObject:self];
}

- (NSString *)stringByReplacingString:(NSString *)string {
    //账号规范：大于7位显示前三后四，小于7位显示首尾两位
    NSString *finishString = string;
    if (string.length <= 7) {
        NSString *symbol = [string substringWithRange:NSMakeRange(1, string.length - 2)];
        NSMutableString *replaceString = [NSMutableString stringWithCapacity:4];
        for (int i = 0; i < symbol.length; i ++) {
            NSString *str = @"*";
            [replaceString appendString:str];
        }
        finishString = [string stringByReplacingCharactersInRange:NSMakeRange(1, string.length - 2) withString:replaceString];
    } else {
        NSString *symbol = [string substringWithRange:NSMakeRange(3, string.length - 7)];
        NSMutableString *replaceString = [NSMutableString stringWithCapacity:4];
        for (int i = 0; i < symbol.length; i ++) {
            NSString *str = @"*";
            [replaceString appendString:str];
        }
        finishString = [string stringByReplacingCharactersInRange:NSMakeRange(3, string.length - 7) withString:replaceString];
    }
    return finishString;
}

/** 根据时间戳转日期 eg:yyyy-MM */
- (NSString *)getTimeStringWithFormat:(NSString *)format {
    if (self && self.length) {
//        NSTimeInterval interval = [self doubleValue] / 1000.0;
        NSTimeInterval interval = [self doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        NSString *dateString = [formatter stringFromDate:date];
        
        return dateString;
    }
    
    return @"";
}

/** 根据日期转时间戳(s) */
- (long long int)getTimeStampWithFormat:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:self];
    
    long long int currentSecond = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return currentSecond;
}


@end
