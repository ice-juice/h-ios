//
//  HBK_ScanViewController.h
//  HBK_Scan
//
//  Created by 黄冰珂 on 2017/11/15.
//  Copyright © 2017年 黄冰珂. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^saoyisaoBlock)(NSString *str);

@interface HBK_ScanViewController : UIViewController

@property(nonatomic,copy)saoyisaoBlock SSBlock;

@end
