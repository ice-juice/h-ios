//
//  RecordsViewController.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/14.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordsViewController : BaseViewController
//记录类别 0-平仓记录 1-成交记录
@property (nonatomic, assign) RecordType recordType;
//币种
@property (nonatomic, copy) NSString *symbols;

@end

NS_ASSUME_NONNULL_END
