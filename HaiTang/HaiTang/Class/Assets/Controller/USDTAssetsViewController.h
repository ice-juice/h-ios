//
//  USDTAssetsViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/16.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface USDTAssetsViewController : BaseViewController
//USDT资产类别
@property (nonatomic, assign) USDTAssetsType assetsType;
//资产账户id
@property (nonatomic, copy) NSString *list_id;

@end

NS_ASSUME_NONNULL_END
