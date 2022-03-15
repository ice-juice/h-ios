//
//  NoticeDetailMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/21.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@class NewModel;

@interface NoticeDetailMainView : BaseMainView

@property (nonatomic, strong) NewModel *newsModel;

- (instancetype)initWithNewModel:(NewModel *)newModel;

@end

NS_ASSUME_NONNULL_END
