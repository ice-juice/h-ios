//
//  UITextField+Category.m
//  Youku
//
//  Created by 吴紫颖 on 2020/5/15.
//  Copyright © 2020 吴紫颖. All rights reserved.
//

#import "UITextField+Category.h"

@implementation UITextField (Category) 

- (instancetype)initWithImageName:(NSString *)imageName placeHolder:(NSString *)placeHolder {
    
    return [self initWithImageName:imageName text:nil textColor:[UIColor blackColor] placeHolder:placeHolder placeHolderColor:[UIColor blackColor] font:kFont(15)];
}

- (instancetype)initWithImageName:(NSString *)imageName text:(NSString * _Nullable)text textColor:(UIColor *)textColor placeHolder:(NSString *)placeHolder placeHolderColor:(UIColor *)placeHolderColor font:(UIFont *)font {
    return [self initWithImageName:imageName text:text textColor:textColor placeHolder:placeHolder placeHolderColor:placeHolderColor font:font hasLine:NO];
}

- (instancetype)initWithImageName:(NSString *)imageName text:(NSString * _Nullable)text textColor:(UIColor *)textColor placeHolder:(NSString *)placeHolder placeHolderColor:(UIColor *)placeHolderColor font:(UIFont *)font hasLine:(BOOL)hasLine {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake(14, 12.5, 17, 20);
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [leftView addSubview:imageView];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.text = text;
    textField.textColor = textColor;
    textField.font = font;
    textField.leftView = leftView;
    if (placeHolder != nil) {
        textField.placeholder = placeHolder;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{ NSForegroundColorAttributeName: kRGB(136, 136, 136) }];
    }
    
    if (hasLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kSeparateLineColor;
        [textField addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(textField);
            make.height.equalTo(0.5);
        }];
    }
    
    return textField;
}

- (instancetype)initWithLeftViewText:(NSString *)leftViewText placeHolder:(NSString *)placeHolder {
    return [self initWithLeftViewText:leftViewText placeHolder:placeHolder hasLine:YES];
}

- (instancetype)initWithLeftViewText:(NSString *)leftViewText placeHolder:(NSString *)placeHolder hasLine:(BOOL)hasLine {
    UILabel *labelLeftView = [UILabel labelWithText:leftViewText textAlignment:NSTextAlignmentLeft textColor:[UIColor grayColor] font:kBoldFont(12)];
    labelLeftView.frame = CGRectMake(0, 0, 40, 50);
        
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = kRGB(16, 16, 16);
    textField.font = kFont(12);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    if (placeHolder != nil) {
        textField.placeholder = placeHolder;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    }
    
    if (hasLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kSeparateLineColor;
        [textField addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(textField);
            make.height.equalTo(0.5);
        }];
    }
    
    return textField;
}

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder {
    return [self initWithPlaceHolder:placeHolder hasLine:YES];
}

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder hasLine:(BOOL)hasLine {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = kRGB(16, 16, 16);
    textField.placeholder = placeHolder;
    textField.font = kFont(12);
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    if (placeHolder != nil) {
        textField.placeholder = placeHolder;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    }
    
    if (hasLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kSeparateLineColor;
        [textField addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(textField);
            make.height.equalTo(0.5);
        }];
    }
        
    return textField;
}

- (instancetype)initNoLeftViewWithPlaceHolder:(NSString *)placeHolder hasLine:(BOOL)hasLine {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = kRGB(16, 16, 16);
    textField.placeholder = placeHolder;
    textField.font = kFont(12);
    
    if (placeHolder != nil) {
        textField.placeholder = placeHolder;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{ NSForegroundColorAttributeName: kRGB(153, 153, 153) }];
    }
    
    if (hasLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kSeparateLineColor;
        [textField addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(textField);
            make.height.equalTo(0.5);
        }];
    }
        
    return textField;
}

@end
