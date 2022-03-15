//
//  NoticeListViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/10.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeListViewController : BaseViewController
//0-平台公告 1-帮助中心
@property (nonatomic, assign) NSInteger listType;

@end

NS_ASSUME_NONNULL_END
