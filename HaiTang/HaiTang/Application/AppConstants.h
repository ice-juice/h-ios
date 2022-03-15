//
//  AppConstants.h
//  xbtce
//
//  Created by 吴紫颖 on 2020/7/8.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#ifndef AppConstants_h
#define AppConstants_h
/** =========================================== 自定义Logger ============================================ */

#ifdef DEBUG
#define Logger(format, ...) printf("%s\n", [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define Logger(...)
#endif

#define kMethodLogger  Logger(@"##### %s\n", __func__);
#define kDeallocLogger Logger(@"##### %@ dealloc\n", [self class]);

/** =========================================== 判断系统版本 ============================================ */

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

/** =========================================== 判断机型 ============================================ */

#define iPhone4s (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)
#define iPhone5s (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define iPhone6s (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < DBL_EPSILON)
#define iPhone6P (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < DBL_EPSILON)
#define iPhone6sp (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)960) < DBL_EPSILON)
#define iPhoneX [[AppDelegate sharedDelegate] isIphoneX]

/** =========================================== 屏幕宽高 ============================================ */
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kMainBundle [NSBundle mainBundle]
#define kUIWindow [[[UIApplication sharedApplication] delegate] window]
#define kAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate
#define kStatusBarHeight (iPhoneX ? 44 : 20)
#define kNavBarHeight (iPhoneX ? 88 : 64)
#define kTabBarHeight (iPhoneX ? 83 : 49)
#define kSafeAreaBottomHeight (iPhoneX ? 34 : 0)
#define kSafeAreaWebViewHeight (iPhoneX ? 34 : 0)
#define kNavBar_44 44

/** =========================================== 颜色 ============================================ */

#define kRGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define kRGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define kHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define kHexRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

//加密
#define kPublicKey(key)  [RSA encryptString:key publicKey:kServerPublicKey]

// 随机颜色
#define kRandomColor kRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kSeparateLineColor        kRGB(236, 236, 236)             // 分割线颜色
#define kTabBarColor              kRGB(255, 255, 255)             //tabBar背景色
#define kTabBarTitleColor         kRGB(98, 102, 107)              //tabBar字体色
#define kTabBarSelectedTitleColor kRGB(0, 102, 237)               //tabBar选中字体色

#define kGreenColor               kRGB(3, 173, 143)
#define kRedColor                 kRGB(205, 61, 88)

#define XX_6(value)     (1.0 * (value) * WIDTH / WIDTH6)
#define YY_6(value)     (1.0 * (value) * LayOutHeight / HEIGHT6)

/** =========================================== 字体 ============================================ */

#define kFont(kSize) [UIFont systemFontOfSize:kSize]
#define kFontName(name, kSize) [UIFont fontWithName:name size:kSize]
#define kBoldFont(kSize) [UIFont boldSystemFontOfSize:kSize]

/** =========================================== 其他 ============================================ */

#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//缓存目录
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define kCachePath [kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"cache_0%@", APP_VERSION]]
#define kBannerCathPath [kCachePath stringByAppendingPathComponent:[@"bannersCache" md5String]]

#define SuppressPerformSelectorLeakWarning(Stuff)  do { \
  _Pragma("clang diagnostic push") \
  _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
   Stuff; \
  _Pragma("clang diagnostic pop") \
} while (0)

typedef void(^RequestResult)(BOOL success);                     // 一次性请求完用这个
typedef void(^RequestMoreResult)(BOOL success, BOOL loadMore);  // 当有分页时用这个
typedef void(^RequestLoginResult)(BOOL success, BOOL isGoogle); //登录时使用这个
typedef void(^RequestMsgResult)(BOOL success, NSString *msg);   //需要返回code码

static int kCountdownSecond = 120;                  // 验证码倒计时
static int kEmailCountdownSecond = 300;             //邮箱验证码
static const CGFloat autoScrollTimeInterval = 2.0;  // 轮播图滚动间隔时间
static int kPayCountdownSecond = 15 * 60;            // 验证码倒计时

static NSString *const kCurrentLanguage = @"currentLanguage";  //当前语言
static NSString *const kTabbarClick = @"kTabbarClick";
static NSString *const kCameraImageName = @"sc_tj";       //照相机默认图片
static NSString *const kToken = @"token";
static NSString *const kNotificationInvalidToken = @"kNotificationInvalidToken";
static NSString *const kNotificationQuotesGoTop = @"kNotificationQuotesGoTop";
static NSString *const kNotificationQuotesLevelTop = @"kNotificationQuotesLevelTop";

//#define Chinese_Simple @"zh-Hans"
#define Chinese_Traditional @"zh-Hant"
#define English @"en"
#define Korean @"ko"
#define Japanese @"ja"

#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Language"]    //table为语言文件名Language.strings

#define isnan(x)                                                         \
( sizeof(x) == sizeof(float)  ? __inline_isnanf((float)(x))          \
: sizeof(x) == sizeof(double) ? __inline_isnand((double)(x))         \
                              : __inline_isnanl((long double)(x)))

//线上地址
#define SERVER_URL @"https://admin.hiexchange.org"// @"https://htx.feihwl.com"
//本地地址
//#define SERVER_URL  @"http://192.168.101.123:8080"

#endif /* AppConstants_h */
