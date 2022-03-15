//
//  NoticeDetailMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "NoticeDetailMainView.h"

#import <WebKit/WebKit.h>

#import "NewModel.h"

@interface NoticeDetailMainView ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbTime;
@property (nonatomic, strong) UILabel *lbContent;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGFloat titleHeight;

@end

@implementation NoticeDetailMainView
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#FFFFFF\"" completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.style.webkitTextFillColor=\"#101010\"" completionHandler:nil];
    
    __block CGFloat webViewHeight;
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (webViewHeight != self.frame.size.height) {
                self.scrollView.contentSize = CGSizeMake(kScreenWidth, webViewHeight + 200 + kNavBarHeight);
                CGRect frame = self.contentView.frame;
                frame.size.height = webViewHeight + self.titleHeight + kNavBarHeight;
                self.contentView.frame = frame;
            }
        });
    }];
}

#pragma mark - Life Cycle
- (instancetype)initWithNewModel:(NewModel *)newModel {
    self = [super init];
    if (self) {
        _newsModel = newModel;
    }
    return self;
}

#pragma mark - Super Class
- (void)setupSubViews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.contentView];
    
    self.lbTitle = [UILabel labelWithText:@"" textColor:kRGB(16, 16, 16) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:20]];
    self.lbTitle.numberOfLines = 0;
    [self.contentView addSubview:self.lbTitle];
    [self.lbTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    self.lbTime = [UILabel labelWithText:@"" textColor:kRGB(102, 102, 102) font:kFont(12)];
    [self.contentView addSubview:self.lbTime];
    [self.lbTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbTitle.mas_bottom).offset(10);
        make.left.equalTo(15);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kRGB(248, 248, 248);
    [self.contentView addSubview:self.lineView];
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(90);
        make.left.right.equalTo(0);
        make.height.equalTo(4);
    }];
    
    [self.contentView addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(0);
    }];
}

- (void)updateView {
    self.lbTitle.text = self.newsModel.title;
    self.titleHeight = [self.newsModel.title heightForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:20] maxWidth:kScreenWidth - 30] + 60;
    [self.lineView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleHeight);
    }];
    self.lbTime.text = self.newsModel.createTime;
    
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
    "<head> \n"
    "<style type=\"text/css\"> \n"
    "body {font-size:15px;}\n"
    "</style> \n"
    "</head> \n"
    "<body>"
    "<script type='text/javascript'>"
    "window.onload = function(){\n"
    "var $img = document.getElementsByTagName('img');\n"
    "for(var p in  $img){\n"
    " $img[p].style.width = '100%%';\n"
    "$img[p].style.height ='auto'\n"
    "}\n"
    "}"
    "</script>%@"
    "</body>"
                            "</html>", self.newsModel.content];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - Setter And Getter
- (WKWebView *)webView {
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];

        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;

        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        wkWebConfig.preferences = preferences;

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400) configuration:wkWebConfig];
        _webView.scrollView.scrollEnabled = NO;
        _webView.userInteractionEnabled = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.backgroundColor = [UIColor clearColor];
    }
    return _webView;
}

@end
