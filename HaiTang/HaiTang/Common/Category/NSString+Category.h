//
//  NSString+Category.h
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Category)
/** 判断字符串是否为空 */
+ (BOOL)isEmpty:(NSString *)str;
/** 获取富文本 */
- (NSAttributedString *)attributedStringWithSubString:(NSString *)subString subColor:(UIColor *)color;

- (NSAttributedString *)attributedStringWithSubStrings:(NSArray<NSString *> *)subStrings subColors:(NSArray<UIColor *> *)colors;

/** 获取富文本 */
- (NSAttributedString *)attributedStringWithSubString:(NSString *)subString subFont:(UIFont *)font;

/** 获取富文本 */
- (NSAttributedString *)attributedStringWithSubString:(NSString *)subString subColor:(UIColor *)color subFont:(UIFont *)font;

/** 获取富文本中间删除线 */
- (NSAttributedString *)attributedStringWithLineColor:(UIColor *)color;

/** 获取自适应高度 */
- (CGFloat)heightForFont:(UIFont *)font maxWidth:(CGFloat)width;

/** 获取自适应宽度 */
- (CGFloat)widthForFont:(UIFont *)font maxHeight:(CGFloat)height;

/**
 Add scale modifier to the file name (without path extension),
 From @"name" to @"name@2x".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
- (NSString *)stringByAppendingNameScale:(CGFloat)scale;

/**
 Add scale modifier to the file path (with path extension),
 From @"name.png" to @"name@2x.png".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon.png" </td><td>"icon@2x.png" </td></tr>
 <tr><td>"icon..png"</td><td>"icon.@2x.png"</td></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon."    </td><td>"icon.@2x"    </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
- (NSString *)stringByAppendingPathScale:(CGFloat)scale;

/**
 Return the path scale.
 
 e.g.
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
- (CGFloat)pathScale;

/** 是否是纯数字 */
- (BOOL)isNumber;

/** 判断是否为整形 */
- (BOOL)isPureInt;

/** 判断是否为浮点形 */
- (BOOL)isPureFloat;

/** 判断字符串是否同时包含数字和字符，并且在最小和最大长度范围内 */
- (BOOL)isValidAlphanumericWithMinLength:(NSInteger)minLength maxLength:(NSInteger)maxLength;

/** 判断昵称 */
- (BOOL)isNickName;

/** 强密码（必须包含大小写字母和数字的组合，不能使用特殊字符，长度在8-30之间）*/
- (BOOL)isStrongPassword;

/** 去掉字符串最后一个字符 */
+ (NSString *)removeTheLastOneStr:(NSString *)string;

/** 邮箱是否合法 */
- (BOOL)isValidEmail;

/** 替换字符 */
- (NSString *)stringByReplacingString:(NSString *)string;

/** 根据时间戳(ms)转日期 eg:yyyy-MM */
- (NSString *)getTimeStringWithFormat:(NSString *)format;

/** 根据日期转时间戳(s) */
- (long long int)getTimeStampWithFormat:(NSString *)format;



@end

NS_ASSUME_NONNULL_END
