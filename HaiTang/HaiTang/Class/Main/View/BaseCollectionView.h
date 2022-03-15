//
//  BaseCollectionView.h
//  BlueLeaf
//
//  Created by XQ on 2018/12/21.
//  Copyright © 2018年 XQ. All rights reserved.
//

#import "BaseMainView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BaseCollectionViewDelegate <BaseMainViewDelegate>

@optional

/** cell点击回调 */
- (void)collectionView:(UICollectionView *)collectionView didSelectedIndex:(NSIndexPath *)indexPath;

@end

@interface BaseCollectionView : BaseMainView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  设置UICollectionView
 *  @param delegate UICollectionView的代理
 *         shouldRefresh 默认 = NO
 *         sectionInset 默认 = UIEdgeInsetsMake(0, 0, 0, 0)
 *  @return 返回一个UICollectionView
 */

- (UICollectionView *)setupCollectionViewWithDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>)delegate lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing;

- (UICollectionView *)setupCollectionViewWithDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>)delegate lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing shouldRefresh:(BOOL)shouldRefresh;

- (UICollectionView *)setupCollectionViewWithDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>)delegate lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing sectionInset:(UIEdgeInsets)sectionInset;

- (UICollectionView *)setupCollectionViewWithDelegate:(id<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>)delegate lineSpacing:(CGFloat)lineSpacing interitemSpacing:(CGFloat)interitemSpacing sectionInset:(UIEdgeInsets)sectionInset shouldRefresh:(BOOL)shouldRefresh;

@end

NS_ASSUME_NONNULL_END

