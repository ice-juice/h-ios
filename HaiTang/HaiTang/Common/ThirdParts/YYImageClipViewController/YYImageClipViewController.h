//
//  YYImageClipViewController.h
//  YYImageClipViewController
//
//  Created by XQ on 2018/12/17.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYImageClipViewController;

@protocol YYImageClipDelegate <NSObject>

- (void)imageCropper:(YYImageClipViewController *)clipViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(YYImageClipViewController *)clipViewController;

@end

@interface YYImageClipViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<YYImageClipDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (instancetype)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
