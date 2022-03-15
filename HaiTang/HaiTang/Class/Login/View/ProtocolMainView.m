//
//  ProtocolMainView.m
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/20.
//  Copyright © 2020 zy. All rights reserved.
//

#import "ProtocolMainView.h"

#import <WebKit/WebKit.h>

#import "ProtocolModel.h"
#import "LoginMainViewModel.h"

@interface ProtocolMainView ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ProtocolMainView
#pragma mark - Super Class
- (void)setupSubViews {
    [self addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kNavBarHeight);
        make.left.right.bottom.equalTo(0);
    }];
}

- (void)updateView {
    ProtocolModel *protocolModel = [(LoginMainViewModel *)self.mainViewModel protocolModel];
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
                            "</html>", protocolModel.content];
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
        _webView.scrollView.scrollEnabled = YES;
        _webView.userInteractionEnabled = YES;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.backgroundColor = [UIColor clearColor];
    }
    return _webView;
}

@end
