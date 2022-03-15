//
//  UIButton+Category.m
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "UIButton+Category.h"
#import "UIImage+Category.h"
#import "StatusHelper.h"

@implementation UIButton (Category)
+ (UIButton *)commonButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector {
    return [UIButton buttonWithTitle:title titleColor:[UIColor whiteColor] highlightedTitleColor:[UIColor whiteColor] font:kFont(18) backgroundColor:[UIColor whiteColor] highlightedBackgroundColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0 cornerRadius:5 target:target selector:selector];
}

- (void)setTitleLeftSpace:(CGFloat)space {
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -(imageSize.width * 2 + space / 2.0), 0.0, 0.0);
    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -(titleSize.width * 2 + space / 2.0));
}

- (void)setTitleRightSpace:(CGFloat)space {
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -space);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, -space, 0.0, 0.0);
}

- (void)setTitleUpSpace:(CGFloat)space {
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, (imageSize.height + space / 2), 0.0);
    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake((titleSize.height + space / 2), 0.0, 0.0, -titleSize.width);
}

- (void)setTitleDownSpace:(CGFloat)space {
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + space / 2), 0.0);
    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + space / 2), 0.0, 0.0, -titleSize.width);
}

- (void)expandClickAreaOfSuperView:(UIView *)superView target:(id)target section:(SEL)section {
    UIButton *button = [UIButton buttonWithTarget:target selector:section];
    [superView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).equalTo(-10);
        make.top.equalTo(self.mas_top).equalTo(-10);
        make.right.equalTo(self.mas_right).equalTo(10);
        make.bottom.equalTo(self.mas_bottom).equalTo(10);
    }];
}

@end
