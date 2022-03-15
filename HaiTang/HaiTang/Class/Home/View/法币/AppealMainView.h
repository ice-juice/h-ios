//
//  AppealMainView.h
//  HaiTang
//
//  Created by 吴紫颖 on 2020/10/28.
//  Copyright © 2020 zy. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AppealMainViewDelegate <BaseMainViewDelegate>
- (void)collection:(UICollectionView *)collectionView didSelectIndex:(NSInteger)index;
- (void)submitAppeal;

@end

@interface AppealMainView : BaseMainView
//订单类型 
@property (nonatomic, copy) NSString *orderType;

- (void)updateImageView;


@end

NS_ASSUME_NONNULL_END
