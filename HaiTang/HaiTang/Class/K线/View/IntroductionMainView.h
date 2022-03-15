//
//  IntroductionMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/11/4.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IntroductionMainViewDelegate <BaseTableViewDelegate>

- (void)tableView:(UITableView *)tableView scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface IntroductionMainView : BaseTableView

@end

NS_ASSUME_NONNULL_END
